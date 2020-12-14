# NOTE:
# We need a workaround to create a PVC with NFS on terraform 0.12.x.
# SEE ALSO:
# - https://github.com/terraform-providers/terraform-provider-kubernetes/pull/590#issuecomment-624926657
# - https://github.com/terraform-providers/terraform-provider-kubernetes/pull/840
resource "kubernetes_storage_class" "nfs" {
  count = var.install_polyaxon != "no" ? 1 : 0
  metadata {
    name = "filestore"
  }
  reclaim_policy      = "Retain"
  storage_provisioner = "nfs"
}
