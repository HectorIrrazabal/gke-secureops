resource "google_container_cluster" "secureops" {
  name     = "secureops-gke"
  location = var.region

  network    = google_compute_network.secureops_vpc.id
  subnetwork = google_compute_subnetwork.secureops_subnet.id

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = true

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = "secureops-pods"
    services_secondary_range_name = "secureops-services"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    gcp_public_cidrs_access_enabled      = false
    private_endpoint_enforcement_enabled = true

    cidr_blocks {
      cidr_block   = "10.20.0.0/24"
      display_name = "secureops-node-subnet"
    }
  }
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }
}

