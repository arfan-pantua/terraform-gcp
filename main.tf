terraform {
  backend "gcs" {
    bucket  = "terraform-bucket-9ab7f4b3-59fb-4c35-846"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "var.project_id"
}

resource "google_compute_instance" "free_server" {
  name         = "free-tier-server"
  machine_type = "e2-micro" # This is the Free Tier eligible type
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }
}