# Upstream | Google Cloud | GKE

This module is used to establish a Rancher (local) managment cluster using [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/google-cloud/gke
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `rancher_hostname` in order to reach the Rancher console via DNS name
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/google-cloud/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init --upgrade ; terraform apply -target=module.google-kubernetes-engine --auto-approve ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
terraform state rm module.google-kubernetes-engine.local_file.kube-config-export ; terraform destroy -target=module.google-kubernetes-engine --auto-approve ; terraform destroy --auto-approve
```

See full argument list for each module in use:
  - Google Network Services: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/google-cloud/network-services
  - Google Kubernetes Engine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/gke
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher

---

## Requirements

| Name | Version |
|------|---------|
| <a name="required_tf_version"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="required_google_provider_version"></a> [google](#provider\_google) | 4.75.0 |
| <a name="required_k8s_provider_version"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="required_helm_provider_version"></a> [helm](#provider\_helm) | >= 2.10.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="google-kubernetes-engine"></a> [google-kubernetes-engine](#google-kubernetes-engine) | ../../../../modules/distribution/gke | n/a |
| <a name="rancher_install"></a> [rancher\_install](#rancher\_install) | ../../../../modules/rancher | n/a |

## Resources

| Name | Source | Version |
|------|--------|---------|
| <a name="first-k8s-setup"></a> [first-setup](#first-setup) | ./main.tf | n/a |
| <a name="helm-ingress-nginx"></a> [ingress-nginx](#ingress-nginx) | ./main.tf | n/a |
| <a name="k8s-ingress-nginx-controller-svc"></a> [ingress-nginx-controller-svc](#ingress-nginx-controller-svc) | ./main.tf | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="prefix"></a> [prefix](#resources\_prefix) | The prefix used in front of all Google resources | `string` | `null` | yes |
| <a name="region"></a> [region](#region) | Google Region used for all resources | `string` | `null` | yes |
| <a name="project_id"></a> [project\_id](#project\_id) | The ID of the Google Project that will contain all created resources | `string` | `null` | yes |
| <a name="ip_cidr_range"></a> [ip\_cidr\_range](#ip\_cidr\_range) | Range of private IPs available for the Google Subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="vpc"></a> [vpc](#vpc) | Google VPC used for all resources | `string` | `null` | yes |
| <a name="subnet"></a> [subnet](#subnet) | Google Subnet used for all resources | `string` | `null` | yes |
| <a name="cluster_version"></a> [cluster\_version](#cluster\_version) | [Supported Google Kubernetes Engine for Rancher Manager](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-7-5/) | `string` | `"1.26.7-gke.500"` | no |
| <a name="instance_count"></a> [instance\_count](#instance\_count) | The number of nodes per instance group | `number` | `1` | no |
| <a name="instance_disk_size"></a> [instance\_disk\_size](#instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="disk_type"></a> [disk\_type](#disk\_type) | Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced') | `string` | `"pd-balanced"` | no |
| <a name="image_type"></a> [image\_type](#image\_type) | The default image type used by NAP once a new node pool is being created. The value must be one of the [COS\_CONTAINERD, COS, UBUNTU\_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24 | `string` | `"cos_containerd"` | no |
| <a name="instance_type"></a> [instance\_type](#instance\_type) | The name of a Google Compute Engine machine type | `string` | `"e2-highmem-2"` | no |
| <a name="kubeconfig_file"></a> [kubeconfig\_file](#kubeconfig\_file) | The kubeconfig to use to interact with the cluster | `string` | `"~/.kube/config"` | no |
| <a name="rancher_hostname"></a> [rancher\_hostname](#rancher\_hostname) | Hostname to set when installing Rancher | `string` | `""` | yes |
| <a name="rancher_password"></a> [rancher\_password](#rancher\_password) | Password to set when installing Rancher | `string` | `"initial-admin-password"` | no |
| <a name="rancher_version"></a> [rancher\_version](#rancher\_version) | Rancher version to use when installing the Rancher helm chart, otherwise use the latest in the stable repository | `string` | `null` | no |

## Outputs

No outputs.
