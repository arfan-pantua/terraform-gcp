terraform {
  backend "gcs" {
    bucket  = "terraform-bucket-9ab7f4b3-59fb-4c35-846"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "var.project_id"
  default_labels {
    labels = var.additional_labels
  }
}


# Create a Network (VPC)
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network-tf"
  auto_create_subnetworks = true
}

# Create a Firewall
resource "google_compute_firewall" "ssh_rule" {
  name    = "demo-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  
  description = "Managed by Terraform: Allow SSH for Ansible"
}

resource "google_os_login_ssh_public_key" "ssh_key" {
  user = "terraform-runner@project-9ab7f4b3-59fb-4c35-846.iam.gserviceaccount.com" # ssh user
  key  = file("./assets/devops-key.pub")
} 
# Create the VM Instance with Labels
resource "google_compute_instance" "vm_instance" {
  name         = "demo-node"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  metadata = {
    enable-oslogin : "TRUE"
  }
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      # You can also label the disk specifically
      labels = {
        type = "boot-disk"
      }
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      // Ephemeral public IP
    }
  }

  # Network tags (used for firewall rules, different from Labels)
  tags = ["web-node", "ansible-ready"]

}