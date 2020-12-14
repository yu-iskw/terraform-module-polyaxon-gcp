// It is impossible to create PVCs of NFS servers with terraform-provider-kubernetes v1.11.1.
// After resolving the issue, we will improve this part.
// SEE ALSO: https://github.com/terraform-providers/terraform-provider-kubernetes/pull/590

# PVC for polyaxon-repos
resource "kubernetes_persistent_volume_claim" "polyaxon_filestore_pvc_repos" {
  count = var.install_polyaxon != "no" ? 1 : 0
  metadata {
    name      = "polyaxon-filestore-pvc-repos"
    namespace = kubernetes_namespace.polyaxon[0].metadata[0].name
    labels = {
      name = "polyaxon-filestore-pvc-repos"
    }
    annotations = {
      name = "polyaxon-filestore-pvc-repos"
    }
  }

  spec {
    # Select the target PV.
    volume_name = kubernetes_persistent_volume.polyaxon_filestore_repos[0].metadata[0].name

    access_modes = ["ReadWriteMany"]

    # Use the custom storage class for PVC with NFS.
    storage_class_name = kubernetes_storage_class.nfs[0].metadata[0].name

    resources {
      limits = {}
      requests = {
        # Convert the unit from Gi to Ti if possible.
        storage = (var.filestore_core.capacity_gb % 1024 == 0
          ? format("%dTi", var.filestore_core.capacity_gb / 1024)
          : format("%dGi", var.filestore_core.capacity_gb)
        )
      }
    }
  }
}


# Extra PVCs
resource "kubernetes_persistent_volume_claim" "polyaxon_filestore_pvc_extras" {
  count = var.kubernetes_enabled ? length(var.filestore_extras) : 0

  metadata {
    name      = "polyaxon-filestore-pvc-${count.index}"
    namespace = kubernetes_namespace.polyaxon[0].metadata[0].name
    labels = {
      name = "polyaxon-filestore-pvc-${count.index}"
    }
    annotations = {
      name = "polyaxon-filestore-pvc-${count.index}"
    }
  }

  spec {
    # Target PV
    volume_name = element(kubernetes_persistent_volume.polyaxon_filestore_extras.*.metadata[0].name, count.index)

    access_modes = ["ReadWriteMany"]

    # Use the custom storage class for PVC with NFS
    storage_class_name = kubernetes_storage_class.nfs[0].metadata[0].name

    resources {
      limits = {}
      requests = {
        # Convert the unit from Gi to Ti if possible.
        storage = (element(var.filestore_extras.*.capacity_gb, count.index) % 1024 == 0
          ? format("%dTi", element(var.filestore_extras.*.capacity_gb, count.index) / 1024)
          : format("%dGi", element(var.filestore_extras.*.capacity_gb, count.index))
        )
      }
    }
  }
}
