instance-id: ${hostname}
local-hostname: ${hostname}
%{ if ip_address != "" }
network:
  version: 2
  ethernets:
    nics:
      match:
        name: en*
      dhcp4: false
      addresses:
        - ${ip_address}
      gateway4: ${ip_gateway}
      nameservers:
        addresses: [${join(", ", dns_servers)}]
%{ endif }
