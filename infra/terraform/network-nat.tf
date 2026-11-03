variable "enable_cloud_nat" {
  description = "Create Cloud NAT for private GKE outbound internet access"
  type        = bool
  default     = false
}

resource "google_compute_router" "secureops" {
  count = var.enable_cloud_nat ? 1 : 0

  name    = "secureops-router"
  region  = var.region
  network = google_compute_network.secureops_vpc.id
}

resource "google_compute_router_nat" "secureops" {
  count = var.enable_cloud_nat ? 1 : 0

  name                               = "secureops-nat"
  router                             = google_compute_router.secureops[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
