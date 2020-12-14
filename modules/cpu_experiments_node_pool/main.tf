resource "google_container_node_pool" "polyaxon_cpu_node_pool" {
  # Loop over var.cpu_node_pools
  count = length(var.cpu_node_pools)

  project  = var.gcp_project
  location = var.gcp_zone
  cluster  = var.cluster_name

  # if is_preemptible is false and machine_type is n1-standard-64, then n1standard64.
  # if is_preemptible is true and machine_type is n1-standard-64, then n1standard64-preemptible.
  name = (var.is_preemptible == true
    ? format("%s-preemptible", replace(element(var.cpu_node_pools.*.machine_type, count.index), "_", "-"))
  : format("%s", replace(element(var.cpu_node_pools.*.machine_type, count.index), "_", "-")))

  initial_node_count = 0

  autoscaling {
    min_node_count = element(var.cpu_node_pools.*.min_node_count, count.index)
    max_node_count = element(var.cpu_node_pools.*.max_node_count, count.index)
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible = var.is_preemptible

    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb

    machine_type = element(var.cpu_node_pools.*.machine_type, count.index)

    oauth_scopes = var.available_scopes

    # The label is used for selecting node pool in polyaxon.
    labels = {
      polyaxon = (var.is_preemptible == true) ? "experiments-preemptible" : "experiments"
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
