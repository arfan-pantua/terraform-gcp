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