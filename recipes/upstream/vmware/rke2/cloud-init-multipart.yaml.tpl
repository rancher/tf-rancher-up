Content-Type: multipart/mixed; boundary="MIMEBOUNDARY"
MIME-Version: 1.0

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/cloud-config
Mime-Version: 1.0

#cloud-config
hostname: ${hostname}
preserve_hostname: false
ssh_pwauth: true

users:
  - name: ${vm_username}
    ssh-authorized-keys:
      - ${ssh_public_key_content}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    lock_passwd: false

chpasswd:
  list: |
    ${vm_username}:rancher
  expire: false

package_update: true
package_upgrade: false

packages:
  - curl
  - wget
  - jq
  - net-tools
  - open-vm-tools

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/x-shellscript
Mime-Version: 1.0

${wait_script}

--MIMEBOUNDARY
Content-Transfer-Encoding: 7bit
Content-Type: text/x-shellscript
Mime-Version: 1.0

${rke2_script}

--MIMEBOUNDARY--
