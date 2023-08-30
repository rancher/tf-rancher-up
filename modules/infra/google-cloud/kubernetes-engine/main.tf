resource "google_container_cluster" "primary" {
  name     = "${var.resources_prefix}-cluster"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1

  min_master_version = var.cluster_version

  network    = var.vpc
  subnetwork = var.subnet
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "primary-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name

  version    = var.cluster_version
  node_count = var.node_count

  node_config {
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    image_type   = var.image_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    machine_type = var.machine_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
