resource "google_storage_bucket" "polyaxon_outputs" {
  project       = var.gcp_project
  name          = "${var.gcp_project}-${var.gke_cluster_name}-outputs"
  location      = var.gcp_region
  storage_class = var.bucket_outputs.storage_class
  force_destroy = var.bucket_outputs.force_destroy

  lifecycle_rule {
    condition {
      age = var.bucket_outputs.age
    }
    action {
      type          = var.bucket_outputs.action_type
      storage_class = var.bucket_outputs.action_storage_class
    }
  }
}

resource "google_storage_bucket" "polyaxon_data" {
  project       = var.gcp_project
  name          = "${var.gcp_project}-${var.gke_cluster_name}-data"
  location      = var.gcp_region
  storage_class = var.bucket_data.storage_class
  force_destroy = var.bucket_data.force_destroy

  lifecycle_rule {
    condition {
      age = var.bucket_data.age
    }
    action {
      type          = var.bucket_data.action_type
      storage_class = var.bucket_data.action_storage_class
    }
  }
}

resource "google_storage_bucket" "polyaxon_logs" {
  project       = var.gcp_project
  name          = "${var.gcp_project}-${var.gke_cluster_name}-logs"
  location      = var.gcp_region
  storage_class = var.bucket_logs.storage_class
  force_destroy = var.bucket_logs.force_destroy

  lifecycle_rule {
    condition {
      age = var.bucket_logs.age
    }
    action {
      type          = var.bucket_logs.action_type
      storage_class = var.bucket_logs.action_storage_class
    }
  }
}
