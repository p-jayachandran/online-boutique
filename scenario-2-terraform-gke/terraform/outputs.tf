
output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "gke_cluster_location" {
  description = "Region of the GKE cluster"
  value       = google_container_cluster.gke.location
}

output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnet_name" {
  description = "Name of the GKE subnet"
  value       = google_compute_subnetwork.subnet.name
}
