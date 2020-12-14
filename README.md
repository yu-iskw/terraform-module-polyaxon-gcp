# terraform-module-polyaxon
This is a terraform module to build a [polyaxon](https://polyaxon.com/) environment on Google Cloud.

- [Architecture Overview](./docs/architecture.md)
- [Troubleshootings](./docs/troubleshooting.md)
- [FAQ](./docs/faq.md)

## Requirements
- terraform 0.12
  - Install: `brew install tfenv`
- helm 2
  - Install: `brew install tokiwong/tap/helm-switcher`
- (Optional) terraform-docs
  - Install: `brew install terraform-docs`
  - NOTE: It is used to generate terraform documentations.

## Basic usage
```hcl-terraform
module "example-usage" {
  source = "git::https://github.com/yu-iskw/terraform-module-polyaxon-gcp?ref=0.1.0"

  gcp_project = var.gcp_project
  gcp_region  = "us-central1"
  gcp_zone    = "us-central1-b"

  // Install polyaxon with terraform
  install_polyaxon = "manual"

  // Define node pools for polyaxon experiments.
  regular_cpu_experiments_node_pool      = module.basic-module-usage.default_regular_cpu_node_pools
  preemptible_cpu_experiments_node_pools = module.basic-module-usage.default_preemptible_cpu_node_pools
  regular_gpu_experiments_node_pools = concat(
    module.basic-module-usage.default_t4_regular_node_pools,
    module.basic-module-usage.default_p100_regular_node_pools,
  )
  preemptible_gpu_experiments_node_pools = concat(
    module.basic-module-usage.default_t4_preemptible_node_pools,
    module.basic-module-usage.default_p100_preemptible_node_pools,
  )
}
```

### Examples
- [Basic example](./examples/basic/): A basic example of the module. It illustrates the minimum requirements.
- [Advanced example](./examples/advanced/): An advanced example of the module. We can understand how to use the variables specifically.
- [Testing environment](./examples/test_env): This is to test the module.

## How to use
1. Install polyaxon
2. Install NVIDIA GPU driver
3. Followup setup

### 1. Install polyaxon
There are the two ways to build a polyaxon environemnt with the module.
The instructions are in the other documents respectively.

* [Build GCP resources with terraform and manually install polyaxon](./docs/install_manually.md)
* <del>[Build GCP resources and install polyaxon with terraform](./docs/install_automatically.md)</del>

When we finishe `terraform apply`, the files below will be generated in your terraform directory.
- `polyaxon-config.yaml`: A configuration to set up polyaxon. We can use it with `helm`.
- `node_pools.md`: A documentation about created kubernetes node pools.

**NOTE**:
Installing polyaxon with terraform is not perfectly stable yet.
I would recommend we install it manually.

### 2. Install NVIDIA GPU driver
We need to install NVIDIA GPU device drivers to use nodes with GPUs.
```bash
$ cd ./terraform-module-polyaxon
$ kubectl apply -f extra_resources/kubernetes/nvidia-driver-installer.yaml

# Or we can use the remote file.
# SEE ALSO: https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
```

### 3. Followup setup
We can't automate everything to set up a polyaxon environment with terraform.
For instance, we have to change the node pool selectors of polyaxon jobs and notebooks respectively.
Such explanations are in [Followup setup](./docs/followup_setup.md).

## Input Variables and Outputs
- [Table of input variables](./docs/inputs.md)
- [Table of outputs](./docs/outputs.md)

## Versions
Although we can flexibly change the polyaxon version with the terraform variable `polyaxon_version`, the table below shows the versions of this module against the polyaxon versions.

|module version|default polyaxon version|
|--------------|------------------------|
|0.1.x         |0.6.1                   |
