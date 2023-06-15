#!/bin/bash

PUBLIC_IP=$$(curl ifconfig.io)

cat > /tmp/config.yaml <<EOF
token: ${rke2_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }
node-external-ip:
  - $$PUBLIC_IP
tls-san:
  - "$${PUBLIC_IP}"
  - "$${PUBLIC_IP}.sslip.io"
${rke2_config}
EOF

%{ if rke2_version != "false" }
export INSTALL_RKE2_VERSION=${rke2_version}
%{ endif }

curl https://get.rke2.io | sh -
cp /tmp/config.yaml /etc/rancher/rke2
systemctl enable rke2-server
systemctl start rke2-server