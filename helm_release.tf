locals {
  config_path = ((var.polyaxon_config_template_path != null)
    ? var.polyaxon_config_template_path
    : "${path.module}/extra_resources/polyaxon/polyaxon-config.yaml.tmpl"
  )
  # Generate a polyaxon config from the template file.
  templated_fields = templatefile(
    local.config_path,
    {
      gcp_project      = var.gcp_project
      postgressql_host = google_sql_database_instance.polyaxon_postgres.ip_address.0.ip_address
      bucket_data      = google_storage_bucket.polyaxon_data.name
      bucket_outputs   = google_storage_bucket.polyaxon_outputs.name
      bucket_logs      = google_storage_bucket.polyaxon_logs.name
      memorystore_host = (length(google_redis_instance.polyaxon_redis) == 1
        ? google_redis_instance.polyaxon_redis[0].host
        : null
      )
      polyaxon_filestore_pvc_repos = google_filestore_instance.polyaxon_filestore_repos.name
    }
  )
}

data "helm_repository" "polyaxon" {
  count = var.install_polyaxon == "auto" ? 1 : 0

  name = "polyaxon"
  url  = "https://charts.polyaxon.com"
}

resource "helm_release" "polyaxon" {
  count = var.install_polyaxon == "auto" ? 1 : 0

  namespace  = kubernetes_namespace.polyaxon[0].metadata[0].name
  repository = data.helm_repository.polyaxon[0].name

  name    = "polyaxon"
  chart   = "polyaxon/polyaxon"
  version = var.polyaxon_version

  recreate_pods = true
  timeout       = 10800

  # Pass the generated polyaxon config.
  values = [local.templated_fields]

  depends_on = [
    google_container_cluster.polyaxon_cluster,
    kubernetes_persistent_volume.polyaxon_filestore_repos,
    google_sql_database.polyaxon,
  ]
}

# TODO remove the resource after finishing the test.
resource "null_resource" "generate_polyaxon_config" {
  # Run this every time.
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "echo '${local.templated_fields}' > ${path.cwd}/polyaxon-config.yaml"
  }
}
