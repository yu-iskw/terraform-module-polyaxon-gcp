resource "google_project_service" "enabled-services" {
  for_each = toset([
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "redis.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "file.googleapis.com",
    "tpu.googleapis.com",
  ])

  project = var.gcp_project
  service = each.key

  disable_on_destroy = false
}
