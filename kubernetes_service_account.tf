resource "kubernetes_service_account" "tiller" {
  count = var.install_polyaxon != "no" ? 1 : 0

  metadata {
    name      = "tiller"
    namespace = kubernetes_namespace.polyaxon[0].metadata[0].name

    # NOTE: If it doesn't work with namespace = polyaxon, let's use below.
    # namespace = "kube-system"
  }

  depends_on = [google_container_cluster.polyaxon_cluster]
}
