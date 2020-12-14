locals {
  # `gcloud services list` enables us to get the names of services.
  services = [
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "file.googleapis.com",
    "tpu.googleapis.com",
  ]
}

resource "google_project_service" "enabled-services" {
  count = length(local.services)

  project = var.gcp_project
  service = local.services[count.index]

  disable_on_destroy = false
}