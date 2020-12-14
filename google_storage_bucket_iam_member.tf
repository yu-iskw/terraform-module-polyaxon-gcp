#
# For polyaxon users
#
resource "google_storage_bucket_iam_member" "sa_polyaxon_outputs_objectAdmin" {
  bucket = google_storage_bucket.polyaxon_outputs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_storage_bucket_iam_member" "user_polyaxon_outputs_objectAdmin" {
  for_each = toset(var.polyaxon_users)

  bucket = google_storage_bucket.polyaxon_outputs.name
  role   = "roles/storage.objectAdmin"
  member = each.key
}

resource "google_storage_bucket_iam_member" "sa_polyaxon_data_objectAdmin" {
  bucket = google_storage_bucket.polyaxon_data.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_storage_bucket_iam_member" "user_polyaxon_data_objectAdmin" {
  for_each = toset(var.polyaxon_users)

  bucket = google_storage_bucket.polyaxon_data.name
  role   = "roles/storage.objectAdmin"
  member = each.key
}

resource "google_storage_bucket_iam_member" "sa_polyaxon_logs_objectAdmin" {
  bucket = google_storage_bucket.polyaxon_logs.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.polyaxon.email}"
}

resource "google_storage_bucket_iam_member" "user_polyaxon_logs_objectAdmin" {
  for_each = toset(var.polyaxon_users)

  bucket = google_storage_bucket.polyaxon_logs.name
  role   = "roles/storage.objectAdmin"
  member = each.key
}
