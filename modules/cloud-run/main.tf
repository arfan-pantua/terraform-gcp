resource "google_cloud_run_service" "default" {
  name     = "cloudrun-tf"
  location = var.run_location

  template {
    spec {
      containers {
        name = "hello"
        ports {
          container_port = 5050
        }
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