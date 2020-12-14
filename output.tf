#
# Service account
#
output "google_service_account_polyaxon" {
  description = "Google service account for polyaxon"
  value = {
    account_id   = google_service_account.polyaxon.account_id,
    display_name = google_service_account.polyaxon.display_name,
    email        = google_service_account.polyaxon.email,
  }
}

output "google_service_account_gcr" {
  description = "Google service account to access GCR"
  value = {
    account_id   = google_service_account.polyaxon_gcr_access.account_id,
    display_name = google_service_account.polyaxon_gcr_access.display_name,
    email        = google_service_account.polyaxon_gcr_access.email,
  }
}

#
# GCS
#
output "default_bucket_config_prod" {
  description = "A standardized bucket configuration for production"
  value = {
    storage_class        = "REGIONAL"
    age                  = 365 * 2
    action_type          = "SetStorageClass"
    action_storage_class = "NEARLINE"
    force_destroy        = false
  }
}

#
# Cloud SQL
#
output "sql_polyaxon" {
  description = "Information about Cloud SQL for polyaxon"
  value = {
    name       = google_sql_database_instance.polyaxon_postgres.name,
    ip_address = google_sql_database_instance.polyaxon_postgres.ip_address.0.ip_address,
  }
}

#
# Cloud Filestore
#
output "filestore_repos" {
  description = "Information about Cloud Filestore for polyaxon repos"
  value = {
    name        = google_filestore_instance.polyaxon_filestore_repos.name,
    ip_address  = google_filestore_instance.polyaxon_filestore_repos.networks.0.ip_addresses.0,
    file_shares = google_filestore_instance.polyaxon_filestore_repos.file_shares.0.name,
  }
}

#
# GKE
#
output "gke_cluster" {
  description = "Information about gke_cluster for polyaxon (`google_container_cluster`)"
  value       = google_container_cluster.polyaxon_cluster
}

# output "k8s_namespace_polyaxon" {
#   description = "kubernetes namespace of polyaxon"
#   value       = kubernetes_namespace.polyaxon[0].metadata.0.name
# }

# output "k8s_service_account_tiller_name" {
#   description = "kubernetes service account name for tiller"
#   value       = kubernetes_service_account.tiller[0].metadata[0].name
# }

# Node pool for polyaxon core.
output "polyaxon_core_node_pool" {
  description = "Information of node pool for polyaxon core (`google_container_node_pool`)"
  value       = google_container_node_pool.polyaxon_core.node_config
}

# Node pools for polyaxon build.
output "polyaxon_builds_node_pool" {
  description = "Information of node pool for polyaxon builds (`google_container_node_pool`)"
  value       = google_container_node_pool.polyaxon_builds
}

# Regular node pool with only CPU
output "regular_cpu_experiments_node_pools" {
  description = "Regular CPU node pools' information for polyaxon experiments"
  value       = module.regular_cpu_node_pools.node_pools
}

# Preemptible node pool with only CPU
output "preemptible_cpu_experiments_node_pools" {
  description = "Preemptible CPU node pools' information for polyaxon experiments"
  value       = module.preemptible_cpu_node_pools.node_pools
}

# Regular node pool names
output "regular_gpu_experiments_node_pools" {
  description = "Regular GPU node pools' information for polyaxon experiments"
  value       = module.regular_gpu_node_pools.node_pools
}

# Preemptible
output "preemptible_gpu_experiments_node_pools" {
  description = "Preemptible GPU node pools' information for polyaxon experiments"
  value       = module.preemptible_gpu_node_pools.node_pools
}

# Default node pools with regular CPU instances.
output "default_regular_cpu_node_pools" {
  description = "Default regular node pools with only CPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-64"
    },
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-32"
    },
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-16"
    },
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-8"
    },
    {
      min_node_count = 0
      max_node_count = 25
      machine_type   = "n1-standard-4"
    },
  ]
}

# Default node pools with preemptible CPU instances.
output "default_preemptible_cpu_node_pools" {
  description = "Default preemptible node pools with only CPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 50
      machine_type   = "n1-standard-64"
    },
    {
      min_node_count = 0
      max_node_count = 50
      machine_type   = "n1-standard-32"
    },
    {
      min_node_count = 0
      max_node_count = 50
      machine_type   = "n1-standard-16"
    },
    {
      min_node_count = 0
      max_node_count = 50
      machine_type   = "n1-standard-8"
    },
    {
      min_node_count = 0
      max_node_count = 50
      machine_type   = "n1-standard-4"
    },
  ]
}

# Default node pools with regular T4 GPU instances.
output "default_t4_regular_node_pools" {
  description = "Default regular node pools with T4 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 4
      }
    },
  ]
}

# Default ode pools with preemptible T4 GPU instances.
output "default_t4_preemptible_node_pools" {
  description = "Default preemptible node pools with T4 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 4
      }
    },
  ]
}
# Default node pools with regular K80 GPU instances.
output "default_k80_regular_node_pools" {
  description = "Default regular node pools with K80 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 4
      }
    },
  ]
}

# Default node pools with preemptible T4 GPU instances.
output "default_k80_preemptible_node_pools" {
  description = "Default preemptible node pools with K80 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-k80"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-k80"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-t4"
        count = 4
      }
    },
  ]
}

# Default node pools with regular P100 GPU instances.
output "default_p100_regular_node_pools" {
  description = "Default regular node pools with P100 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 4
      }
    },
  ]
}

# Default node pools with preemptible P100 GPU instances.
output "default_p100_preemptible_node_pools" {
  description = "Default preemptible node pools with P100 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-p100"
        count = 4
      }
    },
  ]
}
# Default node pools with regular V100 GPU instances.
output "default_v100_regular_node_pools" {
  description = "Default regular node pools with V100 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 4
      }
    },
  ]
}

# Default node pools with preemptible V100 GPU instances.
output "default_v100_preemptible_node_pools" {
  description = "Default preemptible node pools with V100 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-v100"
        count = 4
      }
    },
  ]
}

# Default node pools with regular P4 GPU instances.
output "default_p4_regular_node_pools" {
  description = "Default regular node pools with P4 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 15
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 4
      }
    },
  ]
}

# Default node pools with preemptible P4 GPU instances.
output "default_p4_preemptible_node_pools" {
  description = "Default preemptible node pools with P4 GPU for polyaxon experiments"
  value = [
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-8"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 1
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-16"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 2
      }
    },
    {
      min_node_count = 0
      max_node_count = 30
      machine_type   = "n1-highmem-32"
      guest_accelerator = {
        type  = "nvidia-tesla-p4"
        count = 4
      }
    },
  ]
}
