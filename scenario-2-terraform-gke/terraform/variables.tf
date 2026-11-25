variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "GCP region where GKE will be created"
  type        = string
  default     = "asia-south1"
}
