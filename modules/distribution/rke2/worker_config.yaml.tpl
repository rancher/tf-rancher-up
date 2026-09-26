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
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }
token: ${rke2_token}
node-external-ip: $PUBLIC_IP
node-ip: $PRIVATE_IP
%{ if rke2_config != "false" }
${rke2_config}
%{ endif }
EOF

%{ if rke2_version != "false" }
export INSTALL_RKE2_VERSION=${rke2_version}
%{ endif }

export INSTALL_RKE2_TYPE="agent"
curl https://get.rke2.io | sh -
mkdir -p /etc/rancher/rke2
cp /tmp/config.yaml /etc/rancher/rke2
systemctl enable rke2-agent
systemctl start rke2-agent
