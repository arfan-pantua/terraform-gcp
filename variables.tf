variable "project_id" {
  description = "Project id where resources will be created"
  type        = string
}

variable "additional_labels" {
  description = "A map of additional labels to be included in all resources"
  type        = map(string)
  default     = {}
}