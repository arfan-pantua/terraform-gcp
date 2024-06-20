terraform {
  required_providers {
    google = "5.27.0"
  }

  backend "gcs" {
    bucket = "cloud-build-terraform-backend"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "cloud-build" {
  source = "./modules/cloud-build"
}