resource "google_container_node_pool" "polyaxon_core" {
  name     = "core"
  project  = var.gcp_project
  cluster  = google_container_cluster.polyaxon_cluster.name
  location = google_container_cluster.polyaxon_cluster.zone

  initial_node_count = var.polyaxon_core_node_pool.min_node_count

  autoscaling {
    min_node_count = var.polyaxon_core_node_pool.min_node_count
    max_node_count = var.polyaxon_core_node_pool.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      polyaxon = "core"
      type     = "polyaxon-core"
    }

    oauth_scopes = var.available_scopes
    machine_type = var.polyaxon_core_node_pool.machine_type
    disk_size_gb = var.polyaxon_core_node_pool.disk_size_gb

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# We don't have to always hold the resources of build.
# So, the node pool for build can be preemptible.
resource "google_container_node_pool" "polyaxon_builds" {
  name     = "builds-preemptible"
  project  = var.gcp_project
  cluster  = google_container_cluster.polyaxon_cluster.name
  location = google_container_cluster.polyaxon_cluster.zone

  initial_node_count = var.polyaxon_builds_node_pool.min_node_count

  autoscaling {
    min_node_count = var.polyaxon_builds_node_pool.min_node_count
    max_node_count = var.polyaxon_builds_node_pool.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      polyaxon = "builds"
    }

    oauth_scopes = var.available_scopes
    machine_type = var.polyaxon_builds_node_pool.machine_type
    disk_size_gb = var.polyaxon_builds_node_pool.disk_size_gb
    preemptible  = true

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
