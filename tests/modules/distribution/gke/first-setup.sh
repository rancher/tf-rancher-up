#!/bin/bash

PREFIX=$(cat ./variables.tf | grep -v "#" | grep -iA3 prefix | grep default | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')
REGION=$(cat ./variables.tf | grep -v "#" | grep -iA3 region | grep default | awk -F= '{print $2}' | tr -d '"' | sed 's/ //g')

# Log into the GKE cluster with the credentials used to create it.
export KUBECONFIG="./${PREFIX}_kube_config.yml.backup"
gcloud container clusters get-credentials ${PREFIX}-cluster --region ${REGION}

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

# Backup the KUBECONFIG file and clean up the directory.
cp "./${PREFIX}_kube_config.yml" "./${PREFIX}_kube_config.yml.backup"

export KUBECONFIG="./${PREFIX}_kube_config.yml"

kubectl config view

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

sleep 5

rm ./gke_gcloud_auth_plugin_cache || true
