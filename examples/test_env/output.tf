output "google_service_account_polyaxon" {
  description = "Google service account for polyaxon"
  value       = module.test-polyaxon-env.google_service_account_polyaxon
}

output "google_service_account_gcr" {
  description = "Google service account to access to GCR"
  value       = module.test-polyaxon-env.google_service_account_gcr
}

output "filestore_repos" {
  description = "Information about Cloud Filestore for polyaxon repos"
  value       = module.test-polyaxon-env.filestore_repos
}

output "sql_polyaxon" {
  description = "Information about Cloud SQL for polyaxon"
  value       = module.test-polyaxon-env.sql_polyaxon
}

output "regular_gpu_experiments_node_pool_labels" {
  description = "Regular GPU node pools' information for polyaxon experiments"
  value       = module.test-polyaxon-env.regular_gpu_experiments_node_pools["labels"]
}

output "preemptible_gpu_experiments_node_pool_labels" {
  description = "Preemptible GPU node pools' information for polyaxon experiments"
  value       = module.test-polyaxon-env.preemptible_gpu_experiments_node_pools["labels"]
}
