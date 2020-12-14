# Test terraform project

This is a testing terraform project of terraform-module-polyaxon.
The project will create a polyaxon environment in us-central1-b.

## Required Input Variables
You can modify `variable.tf` to specify below required variable(s).
You can also enter values when executing `terraform plan` every time.

- `gcp_proejct` (string): The GCP project ID. It would be nice to test your personal GCP project.
- `kubernetes_config_context` (string): The kubernetes context name
- `install_polyaxon` (bool): Flag to install polyaxon with helm provider or not

## How to create a polyaxon environment

1. Apply the testing terraform project with `install_polyaxon=false`
2. Create the PVC with Cloud Filestore.
3. Install polyaxon (manually or with terraform)
4. Install NVIDIA GPU driver
5. Connect to polyaxon

### 1. Apply the testing terraform project with `install_polyaxon=false`
If you doesn't specify the required variables in `variables.tf`, terraform show the prompt to enter the values.
```bash
$ cd ./examples/test_env

# Initialize terraform
$ terraform init

# Optional: output terraform logs
$ export TF_LOG=1
$ export TF_LOG_PATH='./terraform.log'

# Apply configurations
$ terraform apply
var.gcp_project
  GCP project ID

  Enter a value:
```

### 2. Create the PVC with Cloud Filestore.
At the time of creating the test environment initially, the kubernetes provider has
[a bug](https://github.com/terraform-providers/terraform-provider-kubernetes/pull/590)
that it is impossible to create persistent volume claim (PVC) of NFS.
We have to create the PVC of polyaxon repo with Cloud Filestore with `kubectl`.
```bash
$ cd ./terraform-module-polyaxon
$ kubectl apply -f extra_resources/kubernetes/polyaxon-firestore-pvc.yaml
```

### 3. Install polyaxon (manually or with terraform)
#### Install polyaxon manually
[the instruction](https://docs.polyaxon.com/setup/kubernetes/) describes how to install polyaxon with helm manually.
```bash
$ cd ./examples/test_env

# Add polyaxon helm repository
helm repo add polyaxon https://charts.polyaxon.com
helm repo update

# Install polyaxon
helm install polyaxon/polyaxon \
    --name=polyaxon \
    --namespace=polyaxon \
    --version 0.6.1 \
    -f ./polyaxon-config.yaml
```

####  Install polyaxon with helm provider
Otherwise, please set `install_polyaxon=true` and execute `terraform apply` again.
```bash
$ terraform apply
```

### 4. Install NVIDIA GPU driver
We need to install NVIDIA GPU device drivers to use nodes with GPUs.

```bash
$ cd ./terraform-module-polyaxon
$ kubectl apply -f extra_resources/kubernetes/nvidia-driver-installer.yaml

# Or we can use the remote file.
# SEE ALSO: https://cloud.google.com/kubernetes-engine/docs/how-to/gpus#installing_drivers
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
```

### 5. Connect to polyaxon

```bash
$ cd ./examples/test_env

# Configure the polyaxon
$ pip install -U polyaxon-cli
$ bash ./scripts/config-polyaxon.sh

# Switch to the GKE cluster of polyaxon.
$ export PROJECT_ID="personal-project"
$ export CLUSTER_NAME="polyaxon-cluster"
$ bash ./scripts/switch.sh "$PROJECT_ID" "$CLUSTER_NAME"

# Get the password to login as the root user.
$ kubectl get secret --namespace polyaxon polyaxon-polyaxon-secret -o jsonpath="{.data.POLYAXON_ADMIN_PASSWORD}" | base64 --decode

# Build a SSH tunnel to polyaxon API.
$ bash scripts/ssh-tunnel.sh

# Open the polyaxon web UI and login as `root`.
$ open http://localhost:31811/
```

### Clean up
```bash
$ terraform destroy
```

## Troubleshooting

### How to change polyaxon version
It seems that it is impossible to upgrade or downgrade polyaxon by changing `version` of `helm_release`.
A workaround is to destroy `helm_release` of polyaxon and then to create it with a different version.

```bash
# Set `install_polyaxon` to `false`.
$ terraform apply

# Set `install_polyaxon` to `true` with a different `polyaxon_version`.
$ terraform apply -targeet=module.test-polyaxon-env.helm_release.polyaxon[0]
```

### Can't access to the GKE cluster.
Even though the provider configuration looks ok according to
[the article](https://stackoverflow.com/questions/57843340/how-to-pass-gke-credential-to-kubernetes-provider-with-terraform)
, we sometimes cannot access the GKE cluster appropriately.
In that case, activating the GKE cluster solves the issue.

```bash
$ terraform apply
...
Error: error installing: Post http://35.222.79.45/apis/apps/v1/namespaces/polyaxon/deployments: dial tcp 35.222.79.45:80: connect: operation timed out
  on ../../../terraform-module-polyaxon/helm_release.tf line 19, in resource "helm_release" "polyaxon":
  19: resource "helm_release" "polyaxon" {

# Activate your cluster
$ GCP_PROJECT="personal-project"
$ CLUSTER_NAME="polyaxon-cluster"
$ gcloud container clusters get-credentials ${CLUSTER_NAME} \
    --zone us-central1-b \
    --project ${GCP_PROJECT}
```

