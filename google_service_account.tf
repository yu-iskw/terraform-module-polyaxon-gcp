#
# Service Accounts
#
resource "google_service_account" "polyaxon" {
  project      = var.gcp_project
  account_id   = "polyaxon-for-${var.gke_cluster_name}"
  display_name = "polyaxon-for-${var.gke_cluster_name}"
}

resource "google_service_account_key" "polyaxon_key" {
  service_account_id = google_service_account.polyaxon.name
}

# Google Container Registory
resource "google_service_account" "polyaxon_gcr_access" {
  project      = var.gcp_project
  account_id   = "gcr-access-for-${var.gke_cluster_name}"
  display_name = "gcr-access-for-${var.gke_cluster_name}"
}

resource "google_service_account_key" "polyaxon_gcr_access_key" {
  service_account_id = google_service_account.polyaxon_gcr_access.name
}
