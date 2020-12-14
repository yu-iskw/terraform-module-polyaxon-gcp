resource "google_redis_instance" "polyaxon_redis" {
  # If it is not enabled, the resource is not created.
  count = (var.memorystore_enabled) ? 1 : 0

  project = var.gcp_project
  region  = var.gcp_region

  // var.gcp_zone = "us-central1-b" then alternative one is "us-central1-c"
  location_id             = var.gcp_zone
  alternative_location_id = replace(var.gcp_zone, "/.$/", substr(replace("abc", regex(".$", var.gcp_zone), ""), 1, 1))

  name           = "${var.gke_cluster_name}-redis"
  display_name   = "Redis for polyaxon in ${var.gcp_project}"
  tier           = "STANDARD_HA"
  memory_size_gb = var.memorystore_size_gb
  redis_version  = "REDIS_4_0"

  authorized_network = google_compute_network.private_network.self_link
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service.enabled-services,
  ]
}
