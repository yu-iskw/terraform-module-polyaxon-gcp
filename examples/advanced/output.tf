output "google_service_account_polyaxon" {
  description = "Google service account for polyaxon"
  value       = module.advanced-module-usage.google_service_account_polyaxon
}

output "google_service_account_gcr" {
  description = "Google service account to access to GCR"
  value       = module.advanced-module-usage.google_service_account_gcr
}

output "filestore_repos" {
  description = "Information about Cloud Filestore for polyaxon repos"
  value       = module.advanced-module-usage.filestore_repos
}

output "sql_polyaxon" {
  description = "Information about Cloud SQL for polyaxon"
  value       = module.advanced-module-usage.sql_polyaxon
}
