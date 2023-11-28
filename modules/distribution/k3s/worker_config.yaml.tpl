#!/bin/bash

PUBLIC_IP=$(curl ifconfig.io)

cat > /tmp/config.yaml <<EOF
token: ${k3s_token}
server: https://${server_ip}:6443
node-external-ip: $PUBLIC_IP
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