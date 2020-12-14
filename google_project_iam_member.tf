#
# GKE
#
resource "google_project_iam_member" "gke_developers" {
  # The resource is required for users to access the polyaxon GKE clusterr.
  # If accessing with SSH tunnel is not appropriate, we have to consider alternative way.
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/container.developer"
  member  = each.key
}

#
# GCS
#
resource "google_project_iam_member" "storage_admin_polyaxon" {
  project = var.gcp_project
  role    = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_project_iam_member" "storage_admin_gcr" {
  project = var.gcp_project
  role    = "roles/storage.objectAdmin"

  member = "serviceAccount:${google_service_account.polyaxon_gcr_access.email}"
}

#
# Cloud TPU
#
resource "google_project_iam_member" "tpu_admin_for_polyaxon_service_account" {
  project = var.gcp_project
  role    = "roles/tpu.admin"

  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_project_iam_member" "tpu_admin_for_polyaxon_users" {
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/tpu.admin"

  member = each.key
}

#
# BigQuery
#
resource "google_project_iam_member" "polyaxon_sa_is_bigquery_user" {
  project = var.gcp_project
  role    = "roles/bigquery.user"

  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_project_iam_member" "bq_user_for_polyaxon_users" {
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/bigquery.user"

  member = each.key
}

#
# Logging
#
resource "google_project_iam_member" "logging_viewer_for_polyaxon_users" {
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/logging.viewer"

  member = each.key
}

#
# Stackdriver
#
resource "google_project_iam_member" "stackdriver_accounts_viewer_developers" {
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/stackdriver.accounts.viewer"

  member = each.key
}

resource "google_project_iam_member" "monitoring_viewer_developers" {
  for_each = toset(var.polyaxon_users)

  project = var.gcp_project
  role    = "roles/monitoring.viewer"

  member = each.key
}
