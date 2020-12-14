resource "kubernetes_namespace" "polyaxon" {
  count = var.install_polyaxon != "no" ? 1 : 0

  metadata {
    name = "polyaxon"
  }
}
