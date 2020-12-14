resource "google_sql_database_instance" "polyaxon_postgres" {
  project = var.gcp_project
  region  = var.gcp_region

  name             = var.sql_name
  database_version = "POSTGRES_9_6"

  settings {
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.private_network.self_link
    }

    location_preference {
      zone = var.gcp_zone
    }

    disk_size = var.sql_disk_size_gb

    # NOTE from https://cloud.google.com/sql/docs/postgres/create-instance#machine-types
    tier = var.sql_settings_tier

    # Mailtenace will be done on 17:00-18:00 Monday JST
    maintenance_window {
      day          = 1
      hour         = 8
      update_track = "stable"
    }

    backup_configuration {
      enabled = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_database" "polyaxon" {
  project  = var.gcp_project
  name     = "polyaxon"
  instance = google_sql_database_instance.polyaxon_postgres.name
  charset  = "UTF8"
}

resource "google_sql_user" "user" {
  project  = var.gcp_project
  name     = "polyaxon"
  instance = google_sql_database_instance.polyaxon_postgres.name
  password = "polyaxon"

  depends_on = [google_sql_database.polyaxon]
}
