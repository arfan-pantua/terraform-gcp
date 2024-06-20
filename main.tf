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

# read latest password version from secret manager
data "google_secret_manager_secret_version" "gitlab_api_token_secret" {
  secret = "gitlab-api-token"
}

data "google_secret_manager_secret_version" "gitlab_read_api_token_secret" {
  secret = "gitlab-read-api-token"
}

data "google_secret_manager_secret_version" "gitlab_webhook_token_secret" {
  secret = "gitlab-webhook-token"
}



resource "google_cloudbuildv2_connection" "gitlab-connection" {
  location = var.build_location
  name     = "gitlab-connection"

  gitlab_config {
    host_uri = var.gitlab_uri
    authorizer_credential {
      user_token_secret_version = data.google_secret_manager_secret_version.gitlab_api_token_secret.name
    }
    read_authorizer_credential {
      user_token_secret_version = data.google_secret_manager_secret_version.gitlab_read_api_token_secret.name
    }
    webhook_secret_secret_version = data.google_secret_manager_secret_version.gitlab_webhook_token_secret.name
  }
}

resource "google_cloudbuildv2_repository" "reborn-repo" {
  name              = "gitlab-reborn-apps"
  location          = var.build_location
  parent_connection = google_cloudbuildv2_connection.gitlab-connection.id
  remote_uri        = var.gitlab_repo_uri
}

resource "google_cloudbuild_trigger" "reborn-tf" {
  name     = "reborn-prod-tf"
  location = var.build_location
  repository_event_config {
    repository = google_cloudbuildv2_repository.reborn-repo.id
    push {
      branch = "^reborn-prod$"
    }
  }
  filename = ".reborn.prod.build.yaml"
}