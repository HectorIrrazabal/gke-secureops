resource "google_service_account" "gke_nodes" {
  account_id   = "secureops-gke-nodes"
  display_name = "SecureOps GKE Node Service Account"
}

resource "google_project_iam_member" "gke_nodes" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_node_pool" "secureops_nodes" {
  name     = "secureops-nodes"
  location = var.region
  cluster  = google_container_cluster.secureops.id

  node_count = 1

  node_config {
    machine_type    = "e2-standard-2"
    disk_type       = "pd-balanced"
    disk_size_gb    = 30
    image_type      = "COS_CONTAINERD"
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    shielded_instance_config {
      enable_secure_boot          = true
      enable_integrity_monitoring = true
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    tags = ["secureops-gke-node"]
  }

  depends_on = [
    google_project_iam_member.gke_nodes
  ]
}
