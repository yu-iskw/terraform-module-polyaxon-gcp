#
# Core
#
resource "kubernetes_persistent_volume" "polyaxon_filestore_repos" {
  count = var.install_polyaxon != "no" ? 1 : 0

  metadata {
    name = "polyaxon-repos"
    labels = {
      name = "polyaxon-repos"
    }
  }

  spec {
    # Use the custom storage class for PVC with NFS
    storage_class_name = kubernetes_storage_class.nfs[0].metadata[0].name
    access_modes       = ["ReadWriteMany"]

    capacity = {
      # Convert the unit from Gi to Ti if possible.
      storage = (var.filestore_core.capacity_gb % 1024 == 0
        ? format("%dTi", var.filestore_core.capacity_gb / 1024)
        : format("%dGi", var.filestore_core.capacity_gb)
      )
    }

    persistent_volume_source {
      nfs {
        path   = "/${google_filestore_instance.polyaxon_filestore_repos.file_shares[0].name}"
        server = google_filestore_instance.polyaxon_filestore_repos.networks.0.ip_addresses.0
      }
    }
  }
}

#
# Extras
#
resource "kubernetes_persistent_volume" "polyaxon_filestore_extras" {
  count = var.kubernetes_enabled ? length(var.filestore_extras) : 0

  metadata {
    name = element(google_filestore_instance.polyaxon_filestore_extras.*.name, count.index)
    labels = {
      name = element(google_filestore_instance.polyaxon_filestore_extras.*.name, count.index)
    }
  }
  spec {
    # Use the custom storage class for PVC with NFS
    storage_class_name = kubernetes_storage_class.nfs[0].metadata[0].name
    access_modes       = ["ReadWriteMany"]
    capacity = {
      # Convert the unit from Gi to Ti if possible.
      storage = (element(var.filestore_extras.*.capacity_gb, count.index) % 1024 == 0
        ? format("%dTi", element(var.filestore_extras.*.capacity_gb, count.index) / 1024)
        : format("%dGi", element(var.filestore_extras.*.capacity_gb, count.index))
      )
    }
    persistent_volume_source {
      nfs {
        path   = "/filestore-extra${count.index}"
        server = element(google_filestore_instance.polyaxon_filestore_extras.*.networks.ip_addresses.0, count.index)
      }
    }
  }

  depends_on = [
    google_container_cluster.polyaxon_cluster,
  ]
}
