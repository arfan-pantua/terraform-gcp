terraform {
  required_providers {
    google = "4.10.0"
  }

  backend "gcs" {
    bucket = "cloud-build-terraform-backend"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
}

resource "google_storage_bucket" "bucket" {
  name     = "test-bucket-random-001122-22"
  location = "${var.region}"
}