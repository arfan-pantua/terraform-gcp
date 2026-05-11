terraform {
  backend "gcs" {
    bucket  = "terraform-bucket-9ab7f4b3-59fb-4c35-846"
    prefix  = "terraform/state"
  }
}

provider "google" {
  project = "var.project_id"
  default_labels = local.additional_labels
}

module "demo_gke" {
  source = "git::https://github.com/arfan-pantua/terraform-gcp-modules.git//modules/gke?ref=v1.0.0"

  cluster_name = local.cluster_name
  kubernetes_version = local.kubernetes_version
  project_id   = var.project_id
  region       = var.region
  ip_range_pods = local.ip_range_pods
  ip_range_services = local.ip_range_services
  additional_labels = local.additional_labels
  
  network = google_compute_network.main.name
  subnetwork = google_compute_subnetwork.main.name

  node_pools = {
    "monitoring" = {
      machine_type   = "e2-micro"
      node_count     = 1
      labels = {
        "dedicated" = "monitoring"
      }
      taints = [
        {
          key    = "dedicated"
          value  = "monitoring"
          effect = "NO_SCHEDULE"
        }
      ]
    },

    "general" = {
      machine_type   = "e2-micro"
      node_count     = 2
      spot           = false
      labels         = {}
      taints         = []
    }
  }
  
  access_entries = {
    power_user = {
      principal = "user:arfanpantua@gmail.com"
      role      = "roles/container.admin"
    }
  }
}

module "grafana_workload_identity" {
  source = "git::https://github.com/arfan-pantua/terraform-gcp-modules.git//modules/workload-identity?ref=v1.0.0"

  project_id             = var.project_id
  namespace              = "grafana"
  service_account_name   = "grafana-sa"
  workload_identity_pool = module.demo_gke.workload_identity_pool

  gcp_roles = [
    "roles/storage.objectViewer",
    "roles/pubsub.publisher",
    "roles/secretmanager.secretAccessor",
  ]
}

module "loki_workload_identity" {
  source = "git::https://github.com/arfan-pantua/terraform-gcp-modules.git//modules/workload-identity?ref=v1.0.0"

  project_id             = var.project_id
  namespace              = "loki"
  service_account_name   = "loki-sa"
  workload_identity_pool = module.demo_gke.workload_identity_pool
  bucket                 = "loki-data"

  gcp_roles = [
    "roles/storage.objectViewer",
    "roles/pubsub.publisher",
    "roles/secretmanager.secretAccessor",
  ]
}