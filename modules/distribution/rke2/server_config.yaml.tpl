#!/bin/bash
if [ ${auto_resolve_public_ip_address} ]
  then
    IP=$(curl ifconfig.io)
  else
    IP=$(ip route get 8.8.8.8 | awk '{print $7}' | head -n 1)
fi


cat > /tmp/config.yaml <<EOF
token: ${rke2_token}
%{ if server_ip != "false" }
server: https://${server_ip}:9345
%{ endif }

%{ if auto_resolve_public_ip_address != false}
node-external-ip: $IP
tls-san:
  - "$IP"
  - "$IP.sslip.io"
%{ endif }
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

cat >> /etc/profile <<EOF
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
export CRI_CONFIG_FILE=/var/lib/rancher/rke2/agent/etc/crictl.yaml
PATH="$PATH:/var/lib/rancher/rke2/bin"
alias k=kubectl
EOF