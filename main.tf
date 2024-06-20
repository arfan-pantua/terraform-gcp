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
  container_image = "asia-southeast1-docker.pkg.dev/msglowid-dev-332604/seller/app.service@sha256:190a274edeb855f4303435dfdfc72c05dc62fa863922e0b7138d06559ab2c15c"
  env_app_name = "app-service-dev-service"
  env_jwt_aud = "app-service-dev"
  env_jwt_expiration = "3600"
  env_mongodb_url = "mongodb+srv://dev-it:410rt7J2MoeDv938@mdb44-kci-sgp1-0002-sellershop-c18dd8cc.mongo.ondigitalocean.com/admin?retryWrites=false&replicaSet=mdb44-kci-sgp1-0002-sellershop&readPreference=primary&srvServiceName=mongodb&connectTimeoutMS=10000&authSource=admin&authMechanism=SCRAM-SHA-1"
  env_mongodb = "seller_app"
}