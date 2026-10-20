locals {
  # Explicit Rancher credentials win; otherwise read them from the upstream recipe's state
  use_remote_state = var.rancher_api_url == null
  api_url          = local.use_remote_state ? data.terraform_remote_state.upstream[0].outputs.rancher_url : var.rancher_api_url
  token_key        = local.use_remote_state ? data.terraform_remote_state.upstream[0].outputs.rancher_token : var.rancher_token_key
}

data "terraform_remote_state" "upstream" {
  count   = local.use_remote_state ? 1 : 0
  backend = "local"
  config = {
    path = var.upstream_state_path
  }
}

resource "rancher2_cluster_v2" "downstream" {
  name               = var.cluster_name
  kubernetes_version = var.rke2_version

  # Authorized Cluster Endpoint. Always present (enabled = false when off): the provider does not
  # clear removed blocks from the Rancher cluster
  local_auth_endpoint {
    enabled  = var.authorized_cluster_endpoint.enabled
    fqdn     = var.authorized_cluster_endpoint.fqdn
    ca_certs = var.authorized_cluster_endpoint.ca_certs
  }

  rke_config {
    machine_global_config = <<-EOT
      cni: "canal"
      ingress-controller: "${local.rke2_ingress}"
    EOT

    # Keep Canal's VXLAN overlay on the VPC interface; the firewall only allows it from the VPC range
    chart_values = <<-EOT
      rke2-canal:
        flannel:
          iface: "${var.private_network_interface}"
    EOT

    # Kubernetes API audit logging (audit.tf); Rancher restarts the control plane to apply changes.
    # Rancher takes the policy *content* in audit-policy-file and writes it to the node itself.
    # The block is always present (empty config when disabled): the provider does not clear
    # removed blocks from the Rancher cluster, so a dynamic block could never switch audit off.
    machine_selector_config {
      machine_label_selector {
        match_labels = local.control_plane_selector
      }
      config = local.kube_audit_enabled ? yamlencode({
        audit-policy-file = local.kube_audit_policy
        kube-apiserver-arg = [
          "audit-log-path=${local.kube_audit_log_path}",
          "audit-log-maxage=${var.kube_audit_log_max_age}",
          "audit-log-maxbackup=${var.kube_audit_log_max_backup}",
          "audit-log-maxsize=${var.kube_audit_log_max_size}",
        ]
      }) : yamlencode({})
    }
  }

  lifecycle {
    precondition {
      condition     = local.token_key != null
      error_message = "No Rancher API token: set rancher_token_key, or deploy the upstream recipe with bootstrap_rancher = true and rancher_password set."
    }
  }
}

locals {
  rke2_ingress = var.rke2_ingress == "traefik" ? "traefik" : "ingress-${var.rke2_ingress}"
  droplet_tags = ["user:${coalesce(var.user_tag, var.prefix)}"]
}

# One VPC for all nodes so RKE2 traffic (etcd, kubelet, CNI) stays on the private network
resource "digitalocean_vpc" "cluster" {
  name   = "${var.prefix}-vpc"
  region = var.region
}

module "rke2_servers" {
  source                      = "../../../../modules/infra/digitalocean/"
  prefix                      = var.prefix
  do_token                    = var.do_token
  droplet_count               = var.droplet_count
  droplet_size                = var.droplet_size
  tag_begin                   = var.tag_begin
  ssh_key_pair_name           = var.ssh_key_pair_name
  ssh_key_pair_path           = var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = var.create_ssh_key_pair
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = null
  create_firewall             = var.create_firewall
  create_https_loadbalancer   = var.create_https_loadbalancer
  create_k8s_api_loadbalancer = var.create_k8s_api_loadbalancer
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
  rke2_installation           = false
  vpc                         = { id = digitalocean_vpc.cluster.id, ip_range = digitalocean_vpc.cluster.ip_range }
  tags                        = local.droplet_tags
}

# Every node runs all roles. --address/--internal-address make RKE2 use the VPC IP for
# node-to-node traffic and advertise the public IP as the external address.
#
# The installer waits until Rancher lets the node join (etcd members join one at a time), which
# can take several minutes. ssh_resource reports a command still running at `timeout` as a
# success, and retries failed commands until `timeout`, so the script gets its own shorter
# deadline and retry_delay outlasts the remaining time: a hung or failed install fails the apply.
resource "ssh_resource" "register_servers" {
  count       = var.droplet_count
  host        = module.rke2_servers.droplets_public_ip[count.index]
  user        = var.ssh_username
  private_key = module.rke2_servers.ssh_private_key
  timeout     = "35m"
  retry_delay = "20m"

  file {
    destination = "/root/rancher-register.sh"
    permissions = "0700"
    content = join(" ", [
      rancher2_cluster_v2.downstream.cluster_registration_token[0].insecure_node_command,
      "--etcd --controlplane --worker",
      "--node-name ${var.prefix}-${count.index + var.tag_begin}",
      "--address ${module.rke2_servers.droplets_public_ip[count.index]}",
      "--internal-address ${module.rke2_servers.droplets_private_ip[count.index]}",
    ])
  }

  commands = [
    "timeout 25m sh /root/rancher-register.sh"
  ]
}

# Wait until Rancher reports the cluster active so `apply` fails if the nodes never come up
resource "rancher2_cluster_sync" "downstream" {
  depends_on    = [ssh_resource.register_servers]
  cluster_id    = rancher2_cluster_v2.downstream.cluster_v1_id
  state_confirm = 3

  timeouts {
    create = "30m"
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content         = rancher2_cluster_sync.downstream.kube_config
  filename        = "${path.cwd}/${var.cluster_name}_kube_config.yml"
  file_permission = "0600"
}
