# Module: cpu_experiments_node_pool
The module is used for creating node pools with CPUs and GPUs in GKE.

- [Inputs and Outputs](./inputs_and_outputs.md)

## Usage
```hcl-terraform
module "regular-gpu-node-pools" {
  source = "./modules/gpu_experiments_node_pool"

  gcp_project      = var.gcp_project
  cluster_name     = google_container_cluster.polyaxon-cluster.name
  gcp_zone         = google_container_cluster.polyaxon-cluster.zone
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = false

  gpu_node_pools = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 4
      }
    },
  ]
}
```
