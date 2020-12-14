locals {
  node_pool_docs = templatefile(
    "${path.module}/extra_resources/docs/node_pools.md.tmpl",
    {
      gcp_project              = var.gcp_project
      gke_location             = google_container_cluster.polyaxon_cluster.location
      disk_type_experiments    = var.disk_type_experiments
      disk_size_gb_experiments = var.disk_size_gb_experiments
      # See the output of cpu_experiments_node_pool module
      regular_cpu_node_pools     = module.regular_cpu_node_pools.node_pools
      preemptible_cpu_node_pools = module.preemptible_cpu_node_pools.node_pools
      # See the output of gpu_experiments_node_pool module
      regular_gpu_node_pools     = module.regular_gpu_node_pools.node_pools
      preemptible_gpu_node_pools = module.preemptible_gpu_node_pools.node_pools
    }
  )
}

# Generate a document about node pools.
#
# NOTE:
# Generating documents with terraform might not be appropriate,
# but it is an easy way to get information about node pools and their labels.
resource "null_resource" "generate_node_pools_docs" {
  # Run this every time.
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo '${local.node_pool_docs}' > ${path.cwd}/node_pools.md"
  }
}
