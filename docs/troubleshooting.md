# Troubleshooting

## Can't access to the GKE cluster.
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

## How to change polyaxon version with the module
It seems that it is impossible to upgrade or downgrade polyaxon by changing `version` of `helm_release`.
A workaround is to destroy `helm_release` of polyaxon and then to create it with a different version.
```bash
# Set `install_polyaxon` to `false`.
$ terraform apply

# Set `install_polyaxon` to `true` with a different `polyaxon_version`.
$ terraform apply -targeet=module.test-polyaxon-env.helm_release.polyaxon[0]
```

## Notebook looks zombie with `Init:CrashLoopBackOff`
Sometimes, notebook environments become zombie because of various reasons.
In such a case, we can see the status with `kubectl` as below.
Besides, `polyaxon notebook stop` doesn't work to remove the pod.

### How to see the status of notebook
First, we check the pod status of notebooks and so forth.
```
$ kubectl get pods --namespace=polyaxon
NAME                                                              READY   STATUS                  RESTARTS   AGE
plx-notebook-2dc93583bc5c4c8ab08c626259bf29aa-65567dbd56-ds5k4    0/1     Init:CrashLoopBackOff   8          25m
```

### How to identify your deployment of the zombie notebook
We can delete the notebook by deleting the deployment itself.
```
# Get the list of deployment
$ kubectl get deployments --namespace=polyaxon
NAME                                               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
plx-notebook-2dc93583bc5c4c8ab08c626259bf29aa      1         1         1            0           33m
plx-notebook-c06f56eb5e2e4684860c33d8734845f7      1         1         1            0           4m
...

# See the details of each deployment one by one.
$ kubectl describe deployment --namespace=polyaxon plx-notebook-2dc93583bc5c4c8ab08c626259bf29aa
```

### Delete the deployment
We have identified which deployment is related to the zombie pod of notebook.
Then, we delete the deployment with `kubectl`.
```
$ kubectl delete deployment --namespace=polyaxon plx-notebook-2dc93583bc5c4c8ab08c626259bf29aa
```


