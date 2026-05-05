#cloud-config

# Default cloud-init configuration
# This is used when no custom user_data is provided

users:
  - name: ${vm_username}
    ssh-authorized-keys:
      - ${ssh_public_key}
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash

package_update: true
package_upgrade: false

packages:
  - curl
  - wget
  - jq
  - net-tools

runcmd:
  - echo "VM provisioned successfully"

final_message: "Cloud-init completed in $UPTIME seconds"
