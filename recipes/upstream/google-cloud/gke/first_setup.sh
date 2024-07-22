#!/bin/bash

# Log into the GKE cluster with the credentials used to create it.
export KUBECONFIG="./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml"
gcloud container clusters get-credentials $(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"')-cluster --region $(cat ./terraform.tfvars | grep -v "#" | grep -i region | awk -F= '{print $2}' | tr -d '"')

sleep 10

# Assign the cluster-admin role to the "client" user created thanks to the master_auth parameter (../../../../modules/distribution/gke/main.tf).
cat <<EOF | kubectl apply -f -
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: client-binding
subjects:
- kind: User
  name: client
roleRef:
  kind: ClusterRole
  name: "cluster-admin"
  apiGroup: rbac.authorization.k8s.io
EOF
# https://cloud.google.com/kubernetes-engine/docs/how-to/api-server-authentication#legacy-auth
# https://stackoverflow.com/questions/58976517/gke-masterauth-clientcertificate-has-no-permissions-to-access-cluster-resource

sleep 5

export KUBECONFIG="./$(cat ./terraform.tfvars | grep -v "#" | grep -i prefix | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')_kube_config.yml" 

kubectl config view

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

sleep 5

rm ./gke_gcloud_auth_plugin_cache || true

sleep 5
