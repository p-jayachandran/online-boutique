
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

# Configure Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create custom VPC network
resource "google_compute_network" "vpc" {
  name                    = "boutique-vpc"
  auto_create_subnetworks = false
}

# Create subnet for GKE
resource "google_compute_subnetwork" "subnet" {
  name          = "boutique-subnet"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.10.0.0/20"

  # Secondary IP range for Kubernetes Pods
  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = "10.20.0.0/16"
  }

  # Secondary IP range for Kubernetes Services
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "10.30.0.0/20"
  }
}

# Create GKE Autopilot cluster
resource "google_container_cluster" "gke" {
  name     = "online-boutique-gke"
  location = var.region

  enable_autopilot = true

  network    = google_compute_network.vpc.id
  subnetwork = google_compute_subnetwork.subnet.id

  # Use the secondary ranges created in the subnet
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-range"
    services_secondary_range_name = "services-range"
  }

  deletion_protection = false

  depends_on = [
    google_compute_subnetwork.subnet
  ]
}
