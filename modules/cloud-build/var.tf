variable "gitlab_repo_uri" {
  type = string
}

variable "gitlab_uri" {
  type = string
}

variable "build_location" {
  type    = string
  default = "asia-southeast1"
}

variable "project_id" {
  description = "Google account id where resources will be created"
  type        = string
}