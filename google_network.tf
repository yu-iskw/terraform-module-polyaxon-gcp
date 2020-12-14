resource "google_compute_network" "private_network" {
  project = var.gcp_project

  name = var.private_network_name

  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "polyaxon_subnet" {
  project = var.gcp_project

  name          = "polyaxon-subnet"
  network       = google_compute_network.private_network.self_link
  ip_cidr_range = "10.128.0.0/20"
  region        = var.gcp_region

  secondary_ip_range {
    range_name    = "container-range"
    ip_cidr_range = "10.132.0.0/20"
  }

  secondary_ip_range {
    range_name    = "service-range"
    ip_cidr_range = "10.138.0.0/20"
  }
}

resource "google_compute_global_address" "private_ip_address" {
  project = var.gcp_project

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.private_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}
