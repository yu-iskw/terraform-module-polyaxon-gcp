resource "google_container_node_pool" "polyaxon-gpu-node-pool" {
  # Loop over var.gpu_node_pools.
  count = length(var.gpu_node_pools)

  project  = var.gcp_project
  location = var.gcp_zone
  cluster  = var.cluster_name

  # If is_preemptible is false and GPU is four T4, then polyaxon-t4x4.
  # If is_preemptible is true and GPU is four T4, then polyaxon-t4x4-preemptible.
  name = (var.is_preemptible == true
    ? format("gpu-%sx%d-preemptible",
      replace(element(var.gpu_node_pools.*.guest_accelerator.type, count.index), "nvidia-tesla-", ""),
      element(var.gpu_node_pools.*.guest_accelerator.count, count.index)
    )
    : format("gpu-%sx%d",
      replace(element(var.gpu_node_pools.*.guest_accelerator.type, count.index), "nvidia-tesla-", ""),
      element(var.gpu_node_pools.*.guest_accelerator.count, count.index)
    )
  )

  initial_node_count = 0

  autoscaling {
    min_node_count = element(var.gpu_node_pools.*.min_node_count, count.index)
    max_node_count = element(var.gpu_node_pools.*.max_node_count, count.index)
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible = var.is_preemptible

    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb

    machine_type = element(var.gpu_node_pools.*.machine_type, count.index)

    oauth_scopes = var.available_scopes

    # The label is used for selecting node pool in polyaxon.
    labels = {
      # e.g.) "experiments-gpu-v100x4-preemptible", "experiments-gpu-k80x1"
      polyaxon = (var.is_preemptible == true
        ? format("experiments-gpu-%sx%d-preemptible",
          replace(element(var.gpu_node_pools.*.guest_accelerator.type, count.index), "nvidia-tesla-", ""),
          element(var.gpu_node_pools.*.guest_accelerator.count, count.index)
        )
        : format("experiments-gpu-%sx%d",
          replace(element(var.gpu_node_pools.*.guest_accelerator.type, count.index), "nvidia-tesla-", ""),
          element(var.gpu_node_pools.*.guest_accelerator.count, count.index)
        )
      )
    }

    metadata = {
      disable-legacy-endpoints = "true"
    }

    guest_accelerator {
      // e.g.) nvidia-gpu-v100
      type = element(var.gpu_node_pools.*.guest_accelerator.type, count.index)
      // The number of accelerators
      count = element(var.gpu_node_pools.*.guest_accelerator.count, count.index)
    }
  }
}
