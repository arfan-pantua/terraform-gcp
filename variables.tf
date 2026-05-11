variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "project_id" {
  description = "Project ID"
  type        = string
  default     = ""
}

variable "region" {
  description = "Project ID"
  type        = string
  default     = "us-central1"
}

variable "bucket" {
  description = "The name of the GCS bucket. If empty, IAM binding will be skipped."
  type        = string
  default     = "" 
}