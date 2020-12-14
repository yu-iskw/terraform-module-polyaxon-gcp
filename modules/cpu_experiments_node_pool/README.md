# Module: cpu_experiments_node_pool
The module is used for creating node pools with CPUs and without GPUs in GKE.

- [Inputs and Outputs](./inputs_and_outputs.md)

## Usage
```hcl-terraform
module "regular-cpu-node-pools" {
  source           = "./modules/cpu_experiments_node_pool"
  gcp_project      = var.gcp_project
  cluster_name     = google_container_cluster.polyaxon-cluster.name
  gcp_zone         = google_container_cluster.polyaxon-cluster.zone
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = false

  cpu_node_pools = [
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-64"
    },
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-32"
    },
  ]
}
```
