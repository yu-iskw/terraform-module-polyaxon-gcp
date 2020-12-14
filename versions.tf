terraform {
  required_version = "~> 0.12"

  required_providers {
    google = ">= 3.27, < 4"
    # google-beta = ">= 2.5, < 3"
    helm = ">= 0.10.3, < 1.0"
  }
}
