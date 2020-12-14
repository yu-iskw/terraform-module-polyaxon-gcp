resource "google_container_cluster" "polyaxon_cluster" {
  provider    = google-beta
  name        = var.gke_cluster_name
  project     = var.gcp_project
  location    = var.gcp_zone
  description = "A GKE cluster of polyaxon created with terraform-module-polyaxon"

  initial_node_count       = 1
  remove_default_node_pool = true

  enable_tpu = true

  enable_legacy_abac = false

  network    = "projects/${var.gcp_project}/global/networks/${google_compute_network.private_network.name}"
  subnetwork = google_compute_subnetwork.polyaxon_subnet.self_link

  # enable VPC native cluster
  ip_allocation_policy {
    cluster_secondary_range_name  = google_compute_subnetwork.polyaxon_subnet.secondary_ip_range.0.range_name
    services_secondary_range_name = google_compute_subnetwork.polyaxon_subnet.secondary_ip_range.1.range_name
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  # Auto upgrade option
  # RAPID: Upgrade per a week, to get the latest Kubernetes release as early as possible
  # REGULAR: Upgrade per several times in a month, you can access GKE and Kubernetes features reasonably soon after they debut
  # STABLE: Upgrade once per several months, prioritize stability over new functionality
  # https://cloud.google.com/kubernetes-engine/docs/concepts/release-channels
  release_channel {
    channel = "REGULAR"
  }

  maintenance_policy {
    daily_maintenance_window {
      # Maintenance window needs 4 hours (UTC)
      # https://cloud.google.com/kubernetes-engine/docs/how-to/maintenance-window
      start_time = "13:00"
    }
  }

  depends_on = [
    google_service_networking_connection.private_vpc_connection,
  ]

  lifecycle {
    # ignore changes to node_pool specifically so it doesn't
    #   try to recreate default node pool with every change
    # ignore changes to network and subnetwork so it doesn't
    #   clutter up diff with dumb changes like:
    #   projects/[name]/regions/us-central1/subnetworks/[name]" => "name"
    ignore_changes = [
      node_pool,
      network,
      subnetwork
    ]
  }
}
