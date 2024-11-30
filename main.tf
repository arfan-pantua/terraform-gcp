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
  gitlab_repo_uri = "https://git.msglow.cloud/greatnest/reborn-apps.git"
  gitlab_uri      = "https://git.msglow.cloud"
  project_id      = "msglowid-dev-332604"
}

module "cloud-run" {
  source = "./modules/cloud-run"
  container_image = "us-docker.pkg.dev/cloudrun/container/hello"
  env_app_name = "app-service-dev-service"
  env_jwt_aud = "app-service-dev"
  env_jwt_expiration = "3600"
  env_mongodb = "seller_app"
}
