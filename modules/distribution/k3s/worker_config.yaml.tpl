#!/bin/bash

# Look up the public IPv4 address, retrying transient failures. If it can't be determined, stop
# before k3s is configured: an empty or garbage address would be written into node-external-ip
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
  echo "ERROR: could not determine the public IP address from icanhazip.com; k3s not configured" >&2
  exit 1
fi

PRIVATE_IP=$(ip addr show scope global | grep inet | cut -d' ' -f6 | cut -d/ -f1 | grep -v "$PUBLIC_IP")
if [ $(echo "$PRIVATE_IP" | wc -l) -gt 1 ];
then
  PRIVATE_IP=$(echo "$PRIVATE_IP" | sed -n '2p');
fi

cat > /tmp/config.yaml <<EOF
token: ${k3s_token}
server: https://${server_ip}:6443
node-external-ip: $PUBLIC_IP
node-ip: $PRIVATE_IP
%{ if k3s_config != "false" }
${k3s_config}
%{ endif }
EOF

%{ if k3s_version != "false" }
export INSTALL_K3S_VERSION=${k3s_version}
#export INSTALL_K3S_CHANNEL=${k3s_channel}
%{ endif }

mkdir -p /etc/rancher/k3s
cp /tmp/config.yaml /etc/rancher/k3s
curl -sfL https://get.k3s.io |INSTALL_K3S_CHANNEL=${k3s_channel} INSTALL_K3S_EXEC="agent" sh -

cat >> /etc/profile <<EOF
alias k=kubectl
EOF