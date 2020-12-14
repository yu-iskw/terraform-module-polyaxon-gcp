resource "kubernetes_cluster_role_binding" "tiller" {
  count = var.install_polyaxon != "no" ? 1 : 0

  metadata {
    name = kubernetes_service_account.tiller[0].metadata[0].name
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller[0].metadata[0].name
    namespace = kubernetes_namespace.polyaxon[0].metadata[0].name
  }

  depends_on = [google_container_cluster.polyaxon_cluster]
}
