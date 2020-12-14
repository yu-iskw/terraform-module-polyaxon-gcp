output "node_pools" {
  description = "Lists of node pool names and labels"
  value = {
    names              = google_container_node_pool.polyaxon-gpu-node-pool[*].name
    labels             = google_container_node_pool.polyaxon-gpu-node-pool[*].node_config[0].labels
    machine_types      = google_container_node_pool.polyaxon-gpu-node-pool[*].node_config[0].machine_type
    disk_types         = google_container_node_pool.polyaxon-gpu-node-pool[*].node_config[0].disk_type
    min_node_counts    = google_container_node_pool.polyaxon-gpu-node-pool[*].autoscaling[0].min_node_count
    max_node_counts    = google_container_node_pool.polyaxon-gpu-node-pool[*].autoscaling[0].max_node_count
    accelerator_types  = google_container_node_pool.polyaxon-gpu-node-pool[*].node_config[0].guest_accelerator[0].type
    accelerator_counts = google_container_node_pool.polyaxon-gpu-node-pool[*].node_config[0].guest_accelerator[0].count
  }
}
