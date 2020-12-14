#
# Plyaxon repo
#
resource "google_filestore_instance" "polyaxon_filestore_repos" {
  name    = "${var.gke_cluster_name}-repos"
  project = var.gcp_project
  zone    = var.gcp_zone
  tier    = var.filestore_core.tier

  file_shares {
    capacity_gb = var.filestore_core.capacity_gb
    name        = "repos"
  }

  networks {
    network = google_compute_network.private_network.name
    modes   = ["MODE_IPV4"]
  }

  depends_on = [google_project_service.enabled-services]
}

#
# Extras
#
// It is impossible to create PVCs of NFS servers with terraform-provider-kubernetes v1.11.1.
// So, it is not good to dynamically create resources.
// After resolving the issue, we will improve this part.
// SEE ALSO: https://github.com/terraform-providers/terraform-provider-kubernetes/pull/590
resource "google_filestore_instance" "polyaxon_filestore_extras" {
  count = length(var.filestore_extras)

  project = var.gcp_project
  zone    = var.gcp_zone
  name    = "${var.gke_cluster_name}-extras-${count.index}"
  tier    = element(var.filestore_extras.*.tier, count.index)

  file_shares {
    capacity_gb = element(var.filestore_extras.*.capacity_gb, count.index)
    name        = "extras${count.index}"
  }

  networks {
    network = google_compute_network.private_network.name
    modes   = ["MODE_IPV4"]
  }

  depends_on = [google_project_service.enabled-services]
}
