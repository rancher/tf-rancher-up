#!/bin/bash

PREFIX=$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')
PUBLIC_IPS=$(cat ./terraform.tfstate | grep nat_ip | awk -F: '{print $2}' | tr -d '"' | tr -d ',' | sed 's/ //g')
PRIVATE_SSH_KEY_PATH=$(cat ./terraform.tfvars | grep -v "#" | grep -i ssh_private_key_path | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')
# If the path of the private SSH key is not defined in the variables...
if [ -z "$(cat ./terraform.tfvars | grep -v "#" | grep -i ssh_private_key_path | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')" ]
then
  # Terraform modules automatically generate the private SSH key; we know where it is generated and with what naming convention.
  PRIVATE_SSH_KEY_PATH=$(ls -A1 ./$PREFIX-ssh_private_key.pem)
fi
SSH_USERNAME=$(cat ./terraform.tfvars | grep -v "#" | grep -i ssh_username | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')

cat > ./rke2-ingress-nginx-config.yaml << EOF
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: rke2-ingress-nginx
  namespace: kube-system
spec:
  valuesContent: |-
    controller:
      admissionWebhooks:
        failurePolicy: Ignore
      service:
        type: NodePort    
EOF
RKE2_INGRESS_NGINX_CONFIG=$(ls -A1 ./rke2-ingress-nginx-config.yaml)

# Copy the previously created file (rke2-ingress-nginx-config.yaml) to all Virtual Machines and then restart the RKE2 services to make the changes.
for node in $PUBLIC_IPS;
do
  ssh-keygen -R $node
  scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $PRIVATE_SSH_KEY_PATH $RKE2_INGRESS_NGINX_CONFIG $SSH_USERNAME@$node:/home/ubuntu/$RKE2_INGRESS_NGINX_CONFIG
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $PRIVATE_SSH_KEY_PATH $SSH_USERNAME@$node "sudo mv /home/ubuntu/$RKE2_INGRESS_NGINX_CONFIG /var/lib/rancher/rke2/server/manifests/$RKE2_INGRESS_NGINX_CONFIG ; sudo systemctl restart rke2-server.service"
done

rm $RKE2_INGRESS_NGINX_CONFIG
