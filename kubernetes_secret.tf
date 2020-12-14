locals {
  gcr_auth = templatefile(
    "${path.module}/extra_resources/polyaxon/gcr_auth.tmpl",
    {
      gcp_project    = var.gcp_project,
      private_key_id = jsondecode(base64decode(google_service_account_key.polyaxon_gcr_access_key.private_key)).private_key_id,
      private_key    = jsondecode(base64decode(google_service_account_key.polyaxon_gcr_access_key.private_key)).private_key
    }
  )
  gcr_auth_config_json = templatefile(
    "${path.module}/extra_resources/polyaxon/gcr_auth_config.json.tmpl",
    {
      auth = local.gcr_auth
    }
  )
}

resource "kubernetes_secret" "polyaxon_gcs_secret" {
  count = var.install_polyaxon != "no" ? 1 : 0
  metadata {
    name      = "gcs-secret"
    namespace = kubernetes_namespace.polyaxon[0].id
  }

  data = {
    "account.json" = base64decode(google_service_account_key.polyaxon_key.private_key)
  }

  depends_on = [google_container_cluster.polyaxon_cluster]
}

# Polyaxon & Google GCR
# SEE ALSO: https://docs.polyaxon.com/integrations/gcr/
resource "kubernetes_secret" "polyaxon_gcr_secret" {
  count = var.install_polyaxon != "no" ? 1 : 0
  metadata {
    name      = "docker-conf"
    namespace = kubernetes_namespace.polyaxon[0].id
  }

  data = {
    "config.json" = base64encode(local.gcr_auth_config_json)
  }

  depends_on = [google_container_cluster.polyaxon_cluster]
}
