#!/bin/bash

PUBLIC_IP=$(curl ifconfig.io)

cat > /tmp/config.yaml <<EOF
token: ${k3s_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }

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

curl https://get.k3s.io | INSTALL_K3S_EXEC="server --node-external-ip=$PUBLIC_IP" sh -
mkdir -p /etc/rancher/k3s
cp /tmp/config.yaml /etc/rancher/k3s
#systemctl enable k3s-server
#systemctl start k3s-server

cat >> /etc/profile <<EOF
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/k3s/agent/etc/crictl.yaml
PATH="$PATH:/var/lib/rancher/k3s/bin"
alias k=kubectl
EOF