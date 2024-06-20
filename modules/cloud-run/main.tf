resource "google_cloud_run_service" "default" {
  name     = "cloudrun-tf"
  location = var.run_location

  template {
    spec {
      containers {
        name = "hello"
        image = var.container_image
        env {
          name = "APP_NAME"
          value = var.env_app_name
        }
        env {
          name = "JWT_AUD"
          value = var.env_jwt_aud
        }
        env {
          name = "JWT_EXPIRATION"
          value = var.env_jwt_expiration
        }
        env {
          name = "MONGODB_URL"
          value = var.env_mongodb_url
        }
        env {
          name = "MONGODB_DATABASE"
          value = var.env_mongodb
        }
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}