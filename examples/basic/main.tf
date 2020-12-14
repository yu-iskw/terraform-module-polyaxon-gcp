# NOTE: Cloud SQL doesn't enables us to create an instance whose name is
#       is the same as one which was deleted within 1 week.
#       So, it would be nice to provide a variable to change the name easily.
#       We are not sure if a terraform environment which wants to use the module
#       can use the random provider or not, we should not use the resources in the module.
resource "random_id" "suffix" {
  byte_length = 4
}

module "basic-module-usage" {
  source = "../../../terraform-module-polyaxon"

  # GCP location
  gcp_project = var.gcp_project
  gcp_region  = "us-central1"
  gcp_zone    = "us-central1-b"

  # Polyaxon
  install_polyaxon = "manual"
  polyaxon_version = "0.6.1"

  # Register IAM of polyaxon developers
  polyaxon_users = [
    "user:yu@example.com"
  ]

  # GKE
  gke_cluster_name = "basic_example_polyaxon"

  # Cloud SQL
  sql_name = "polyaxon-sql-${random_id.suffix.id}"

  # GCS
  # If you want to create the GCS buckets as more production mode,
  # using the output would be good.
  // bucket_data = module.test-polyaxon-env.default_bucket_config_prod
  // bucket_output = module.test-polyaxon-env.default_bucket_config_prod
  // bucket_logs = module.test-polyaxon-env.default_bucket_config_prod

  # GKE
  regular_cpu_experiments_node_pool      = module.basic-module-usage.default_regular_cpu_node_pools
  preemptible_cpu_experiments_node_pools = module.basic-module-usage.default_preemptible_cpu_node_pools

  # For instance, we can't use P4 and P100 in us-central1-b.
  # We can make sure of available accelerator in GCP.
  # `gcloud compute accelerator-types list`
  regular_gpu_experiments_node_pools = concat(
    module.basic-module-usage.default_t4_regular_node_pools,
    module.basic-module-usage.default_p100_regular_node_pools,
    // module.test-polyaxon-env.default_k80_regular_node_pools,
    // module.test-polyaxon-env.default_p4_regular_node_pools,
  )
  preemptible_gpu_experiments_node_pools = concat(
    module.basic-module-usage.default_t4_preemptible_node_pools,
    module.basic-module-usage.default_p100_preemptible_node_pools,
    // module.test-polyaxon-env.default_k80_preemptible_node_pools,
    // module.test-polyaxon-env.default_p4_preemptible_node_pools,
  )
}
