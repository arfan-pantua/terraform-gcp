variable "container_image" {
  type = string
}

variable "run_location" {
  type = string
  default = "asia-southeast1"
}

variable "env_app_name" {
  type = string
}
variable "env_jwt_aud" {
  type = string
}
variable "env_jwt_expiration" {
  type = string
}
variable "env_mongodb_url" {
  type = string
}
variable "env_mongodb" {
  type = string
}