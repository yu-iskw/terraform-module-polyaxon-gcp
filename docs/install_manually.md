# Manually install polyaxon with helm

This document describes how to build the GCP environment for polyaxon and to manually install polyaxon with helm.
If you want to control the installation more flexibly, this way would be great.

1. Create module with `install_polyaxon=false`
2. Install polyaxon with helm

## 1. Create module with `install_polyaxon=false`
Setting `install_polyaxon=false` enables us not to install polyaxon with terraform.

```bash
$ terraform init
$ terraform apply
```

## 2. Install polyaxon with helm
[The official documentation](https://docs.polyaxon.com/setup/kubernetes/#install-polyaxon) describes how to install polyaxon.
The commands below enables us to install polyaxon 0.6.1 with helm.
```bash
# Initialize helm
$ helm init --wait

# Add polyaxon helm repository
$ helm repo add polyaxon https://charts.polyaxon.com
$ helm repo update

# Install polyaxon with helm2
$ helm install polyaxon/polyaxon \
     --name=polyaxon \
     --namespace=polyaxon \
     -f ./polyaxon-config.yaml

# (Optional) Upgrade polyaxon or apply a modified polyaxon config
$ helm upgrade polyaxon/polyaxon \
     --name=polyaxon \
     --namespace=polyaxon \
     -f ./polyaxon-config.yaml

# (Optional) Cleanup
$ helm delete polyaxon --purge --no-hooks
```

## Troubleshootings

### Fail to modify PVCs with terraform
We may sometimes fail to modify PVCs with terraform.
#### Error Message
```bash
module.test-polyaxon-env.kubernetes_persistent_volume_claim.polyaxon_filestore_pvc_repos: Still creating... [4m40s elapsed]
module.test-polyaxon-env.kubernetes_persistent_volume_claim.polyaxon_filestore_pvc_repos: Still creating... [4m50s elapsed]
module.test-polyaxon-env.kubernetes_persistent_volume_claim.polyaxon_filestore_pvc_repos: Still creating... [5m0s elapsed]

Error: timeout while waiting for state to become 'Bound' (last state: 'Pending', timeout: 5m0s)
   * polyaxon-filestore-pvc-repos (PersistentVolumeClaim): ExternalExpanding: Ignoring the PVC: didn't find a plugin capable of expanding the volume; waiting for an external controller to process this PVC.

  on ../../../terraform-module-polyaxon/kubernetes_pvc.tf line 6, in resource "kubernetes_persistent_volume_claim" "polyaxon_filestore_pvc_repos":
   6: resource "kubernetes_persistent_volume_claim" "polyaxon_filestore_pvc_repos" {
```
#### Solution
One of the solutions is to destroy the PVs and PVCs and then to create them again.
We don't have to be anxious about losing the data, since the data itself is stored in Cloud Filestore.
PVs and PVCs are just virtual resources on kubernetes.
```bash
# Check PVs and PVCs
$ terraform state list | grep kubernetes_persistent_volume
module.test-polyaxon-env.kubernetes_persistent_volume.polyaxon_filestore_repos
module.test-polyaxon-env.kubernetes_persistent_volume_claim.polyaxon_filestore_pvc_repos

# Destroy target PVs
$ terraform destroy -target module.test-polyaxon-env.kubernetes_persistent_volume.polyaxon_filestore_repos

# Create PVCs again
$ terraform apply -target module.test-polyaxon-env.kubernetes_persistent_volume_claim.polyaxon_filestore_pvc_repos
```

