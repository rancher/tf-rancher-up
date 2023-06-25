#!/bin/bash

PUBLIC_IP=$(curl ifconfig.io)

cat > /tmp/config.yaml <<EOF
token: ${k3s_token}
%{ if server_ip != "false" }
server: https://${server_ip}:6443
%{ else }
cluster-init: true
%{ endif }
node-external-ip: $PUBLIC_IP
tls-san:
  - "$PUBLIC_IP"
  - "$PUBLIC_IP.sslip.io"
%{ if k3s_config != "false" }
${k3s_config}
%{ endif }
EOF

%{ if k3s_version != "false" }
export INSTALL_K3S_VERSION=${k3s_version}
%{ endif }

mkdir -p /etc/rancher/k3s
cp /tmp/config.yaml /etc/rancher/k3s
curl https://get.k3s.io | INSTALL_K3S_CHANNEL=${k3s_channel} sh -

cat >> /etc/profile <<EOF
alias k=kubectl
EOF