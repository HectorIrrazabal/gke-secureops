resource "google_compute_network" "secureops_vpc" {
  name                    = "secureops-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "secureops_subnet" {
  name                     = "secureops-subnet"
  ip_cidr_range            = "10.20.0.0/24"
  region                   = var.region
  network                  = google_compute_network.secureops_vpc.id
  private_ip_google_access = true
}
