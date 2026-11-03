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

  secondary_ip_range {
    range_name    = "secureops-pods"
    ip_cidr_range = "10.40.0.0/16"
  }

  secondary_ip_range {
    range_name    = "secureops-services"
    ip_cidr_range = "10.50.0.0/20"
  }
}
