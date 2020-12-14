# FAQ

## How can we know the labels of GPU node pools?
We provides the outputs to get a list of names and a list of labels.
- `regular_gpu_experiments_node_pools`
- `preemptible_gpu_experiments_node_pools`

We can also add the outputs below in our terraform project outside of the module.
Moreover, `terraform output` enables us to get the labels of GPU node pools.

```hcl-terraform
output "regular_gpu_experiments_node_pool_labels" {
  description = "Regular GPU node pools' information for polyaxon experiments"
  value       = module.test-polyaxon-env.regular_gpu_experiments_node_pools["labels"]
}

output "preemptible_gpu_experiments_node_pool_labels" {
  description = "Preemptible GPU node pools' information for polyaxon experiments"
  value       = module.test-polyaxon-env.preemptible_gpu_experiments_node_pools["labels"]
}
```
