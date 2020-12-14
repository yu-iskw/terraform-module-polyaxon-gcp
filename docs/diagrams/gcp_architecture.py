from diagrams import Cluster, Diagram, Edge
from diagrams.gcp.database import SQL, Memorystore
from diagrams.gcp.storage import GCS, Filestore
from diagrams.gcp.ml import TPU
from diagrams.onprem.mlops import Polyaxon
from diagrams.oci.compute import BareMetal

graph_attr = {
  "rankdir": "TB",
  "mindist": "100.0",
}

with Diagram("GCP Architecture", show=False, outformat="png", graph_attr=graph_attr):

  with Cluster("Local") as local:
    local_machine = BareMetal("Local machine")

  with Cluster("Google Cloud") as gcp:

    tpu = TPU("Cloud TPU")

    with Cluster("Google Cloud Storage") as gcs:
      bucket_data = GCS("polyaxon data")
      bucket_outputs = GCS("polyaxon outputs")
      bucket_logs = GCS("polyaxon logs")

    with Cluster("Private VPC") as vpc:
      cloud_sql = SQL("CloudSQL\n(Postgres)")
      polyaxon_repos = Filestore("Google Filestore\n(polyaxon-repos)")
      redis = Memorystore("Cloud Memorystore\n(optional)")

      with Cluster("GKE") as gke:
        polyaxon = Polyaxon("polyaxon")

  local_machine - Edge(label="SSH tunnel", minlen="3.0") - polyaxon
  polyaxon - [cloud_sql, polyaxon_repos, redis, tpu,
              bucket_data, bucket_logs, bucket_outputs]

