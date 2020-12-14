module "regular_cpu_node_pools" {
  source           = "./modules/cpu_experiments_node_pool"
  gcp_project      = var.gcp_project
  cluster_name     = google_container_cluster.polyaxon_cluster.name
  gcp_zone         = google_container_cluster.polyaxon_cluster.zone
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = false

  cpu_node_pools = var.regular_cpu_experiments_node_pool
}


module "preemptible_cpu_node_pools" {
  source = "./modules/cpu_experiments_node_pool"

  gcp_project      = var.gcp_project
  gcp_zone         = google_container_cluster.polyaxon_cluster.zone
  cluster_name     = google_container_cluster.polyaxon_cluster.name
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = true

  cpu_node_pools = var.preemptible_cpu_experiments_node_pools
}

module "regular_gpu_node_pools" {
  source = "./modules/gpu_experiments_node_pool"

  gcp_project      = var.gcp_project
  cluster_name     = google_container_cluster.polyaxon_cluster.name
  gcp_zone         = google_container_cluster.polyaxon_cluster.zone
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = false

  gpu_node_pools = var.regular_gpu_experiments_node_pools
}

module "preemptible_gpu_node_pools" {
  source = "./modules/gpu_experiments_node_pool"

  gcp_project      = var.gcp_project
  gcp_zone         = google_container_cluster.polyaxon_cluster.zone
  cluster_name     = google_container_cluster.polyaxon_cluster.name
  available_scopes = var.available_scopes

  disk_size_gb   = var.disk_size_gb_experiments
  is_preemptible = true

  gpu_node_pools = var.preemptible_gpu_experiments_node_pools
}
