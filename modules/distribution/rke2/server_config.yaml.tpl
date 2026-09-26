#!/bin/bash

# Look up the public IPv4 address, retrying transient failures. If it can't be determined, stop
# before RKE2 is configured: an empty or garbage address would be written into node-external-ip
# and tls-san, and the empty value would also blank out PRIVATE_IP below. Exiting non-zero fails
# cloud-init, which infra modules waiting on `cloud-init status --wait` report as an error.
PUBLIC_IP=""
for attempt in $(seq 1 10); do
  PUBLIC_IP=$(curl -4 -s --fail --max-time 10 http://icanhazip.com | tr -d '[:space:]')
  if echo "$PUBLIC_IP" | grep -Eq '^([0-9]{1,3}\.){3}[0-9]{1,3}$'; then
    break
  fi
  PUBLIC_IP=""
  echo "Attempt $attempt: could not determine the public IP address, retrying" >&2
  sleep 6
done
if [ -z "$PUBLIC_IP" ]; then
  echo "ERROR: could not determine the public IP address from icanhazip.com; RKE2 not configured" >&2
  exit 1
fi

PRIVATE_IP=$(ip addr show scope global | grep inet | cut -d' ' -f6 | cut -d/ -f1 | grep -v "$PUBLIC_IP")

cat > /tmp/config.yaml <<EOF
token: ${rke2_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }
ingress-controller: ${rke2_ingress}
node-external-ip: $PUBLIC_IP
node-ip: $PRIVATE_IP
advertise-address: $PRIVATE_IP
tls-san:
  - "$PUBLIC_IP"
  - "$PUBLIC_IP.sslip.io"
%{ if rke2_config != "false" }
${rke2_config}
%{ endif }
EOF

%{ if rke2_version != "false" }
export INSTALL_RKE2_VERSION=${rke2_version}
%{ endif }

curl https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2
cp /tmp/config.yaml /etc/rancher/rke2
systemctl enable rke2-server
systemctl start rke2-server

cat > /var/lib/rancher/rke2/server/manifests/rke2-ingress-nginx-config.yaml << EOF
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      admissionWebhooks:
        failurePolicy: Ignore
EOF

cat >> /etc/profile <<EOF
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
PATH="$PATH:/var/lib/rancher/rke2/bin"
alias k=kubectl
EOF