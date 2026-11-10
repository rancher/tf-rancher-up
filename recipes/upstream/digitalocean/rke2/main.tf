locals {
  rke2_installation     = true
  kc_path               = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file               = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  first_node_droplet_id = module.rke2_first_server.droplet_ids
  rke2_ingress          = var.rke2_ingress == "traefik" ? "traefik" : "ingress-${var.rke2_ingress}"
  droplet_tags          = ["user:${coalesce(var.user_tag, var.prefix)}"]
}

# One VPC shared by every node so RKE2 traffic (etcd, kubelet, CNI) stays on the private network
resource "digitalocean_vpc" "cluster" {
  name   = "${var.prefix}-vpc"
  region = var.region
}

module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
  rke2_ingress = local.rke2_ingress
}

module "rke2_first_server" {
  source                      = "../../../../modules/infra/digitalocean/"
  prefix                      = var.prefix
  do_token                    = var.do_token
  droplet_count               = 1
  droplet_size                = var.droplet_size
  ssh_key_pair_name           = var.ssh_key_pair_name
  ssh_key_pair_path           = var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = var.create_ssh_key_pair
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = local.kube_audit_enabled ? "#!/bin/bash\n${local.kube_audit_user_data}${module.rke2_first.rke2_user_data}" : module.rke2_first.rke2_user_data
  create_firewall             = false
  create_https_loadbalancer   = false
  create_k8s_api_loadbalancer = false
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
  rke2_installation           = local.rke2_installation
  vpc                         = { id = digitalocean_vpc.cluster.id, ip_range = digitalocean_vpc.cluster.ip_range }
  tags                        = local.droplet_tags
}

module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.droplets_private_ip[0]
  rke2_ingress    = local.rke2_ingress
}

module "rke2_additional_servers" {
  source        = "../../../../modules/infra/digitalocean/"
  depends_on    = [module.rke2_first_server]
  prefix        = var.prefix
  do_token      = var.do_token
  droplet_count = var.droplet_count - 1
  droplet_size  = var.droplet_size
  tag_begin     = var.tag_begin
  # A generated key pair is owned by rke2_first_server; the module finds it by its generated name/path when these are null
  ssh_key_pair_name           = var.create_ssh_key_pair ? null : var.ssh_key_pair_name
  ssh_key_pair_path           = var.create_ssh_key_pair ? null : var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = false
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = local.kube_audit_enabled ? "#!/bin/bash\n${local.kube_audit_user_data}${module.rke2_additional.rke2_user_data}" : module.rke2_additional.rke2_user_data
  create_firewall             = var.create_firewall
  create_https_loadbalancer   = var.create_https_loadbalancer
  create_k8s_api_loadbalancer = var.create_k8s_api_loadbalancer
  extra_droplet_id            = local.first_node_droplet_id
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
  rke2_installation           = local.rke2_installation
  vpc                         = { id = digitalocean_vpc.cluster.id, ip_range = digitalocean_vpc.cluster.ip_range }
  tags                        = local.droplet_tags
}

# Pin Canal's VXLAN overlay to the VPC interface (by default it uses eth0, the public one,
# where the firewall blocks it). RKE2 applies manifests from this directory cluster-wide;
# Canal is already running by then, so wait for the new config and restart it.
resource "ssh_resource" "canal_private_interface" {
  depends_on = [module.rke2_additional_servers]

  host        = module.rke2_first_server.droplets_public_ip[0]
  user        = var.ssh_username
  private_key = module.rke2_first_server.ssh_private_key
  # Script is bounded to ~10m; see register_servers in the downstream recipe for why
  timeout     = "20m"
  retry_delay = "15m"

  file {
    destination = "/var/lib/rancher/rke2/server/manifests/rke2-canal-config.yaml"
    permissions = "0600"
    content     = <<-EOT
      apiVersion: helm.cattle.io/v1
      kind: HelmChartConfig
      metadata:
        name: rke2-canal
        namespace: kube-system
      spec:
        valuesContent: |-
          flannel:
            iface: "${var.private_network_interface}"
    EOT
  }

  commands = [
    <<-EOT
      set -e
      k="/var/lib/rancher/rke2/bin/kubectl --kubeconfig /etc/rancher/rke2/rke2.yaml -n kube-system"
      for i in $(seq 1 60); do
        [ "$($k get configmap rke2-canal-config -o jsonpath='{.data.canal_iface}' 2>/dev/null)" = "${var.private_network_interface}" ] && break
        [ "$i" = 60 ] && { echo "rke2-canal-config never picked up iface ${var.private_network_interface}" >&2; exit 1; }
        sleep 5
      done
      $k rollout restart daemonset/rke2-canal
      $k rollout status daemonset/rke2-canal --timeout=5m
    EOT
  ]
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [module.rke2_additional_servers, ssh_resource.canal_private_interface]

  host = module.rke2_first_server.droplets_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.droplets_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.ssh_username
  private_key = module.rke2_first_server.ssh_private_key
  timeout     = "10m"
  retry_delay = "10s"
}

resource "local_sensitive_file" "kube_config_yaml" {
  filename        = pathexpand(local.kc_file)
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

provider "kubernetes" {
  config_path = local_sensitive_file.kube_config_yaml.filename
}

provider "helm" {
  kubernetes = {
    config_path = local_sensitive_file.kube_config_yaml.filename
  }
}

locals {
  rancher_hostname = join(".", [var.rancher_hostname, module.rke2_first_server.droplets_public_ip[0], "sslip.io"])

  # Rancher 2.11+ charts need auditLog.enabled; setting only the level logs nothing
  rancher_audit_log_values = var.rancher_audit_log_level == 0 ? [] : compact([
    "auditLog.enabled: true",
    "auditLog.level: ${var.rancher_audit_log_level}",
    "auditLog.destination: ${var.rancher_audit_log_destination}",
    var.rancher_audit_log_destination == "hostPath" ? "auditLog.hostPath: ${var.rancher_audit_log_host_path}" : "",
    var.rancher_audit_log_max_age != null ? "auditLog.maxAge: ${var.rancher_audit_log_max_age}" : "",
    var.rancher_audit_log_max_backup != null ? "auditLog.maxBackup: ${var.rancher_audit_log_max_backup}" : "",
    var.rancher_audit_log_max_size != null ? "auditLog.maxSize: ${var.rancher_audit_log_max_size}" : "",
  ])
}

module "rancher_install" {
  source                                = "../../../../modules/rancher"
  dependency                            = var.droplet_count > 1 ? module.rke2_additional_servers.dependency : module.rke2_first_server.dependency
  kubeconfig_file                       = local_sensitive_file.kube_config_yaml.filename
  rancher_hostname                      = local.rancher_hostname
  rancher_bootstrap_password            = var.rancher_bootstrap_password
  rancher_password                      = var.rancher_password
  bootstrap_rancher                     = var.bootstrap_rancher
  rancher_version                       = var.rancher_version
  rancher_replicas                      = min(var.rancher_replicas, var.droplet_count)
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
  rancher_additional_helm_values = concat([
    "ingress.ingressClassName: ${coalesce(var.rancher_ingress_class_name, var.rke2_ingress)}",
    "service.type: ${var.rancher_service_type}"
  ], local.rancher_audit_log_values, var.rancher_additional_helm_values)
}
