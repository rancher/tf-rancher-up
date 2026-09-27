#!/bin/bash

PUBLIC_IP=$(curl -s http://icanhazip.com)
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
