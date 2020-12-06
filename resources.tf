# Create the GKE cluster removing the default node pool created by GKE upon cluster creation
resource "google_container_cluster" "gke" {
  name     = var.gke_cluster_name
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {} # Define block for VPC-Native Cluster
}

# Create the new managed default node pool with autoscaling
resource "google_container_node_pool" "default_node_pool" {
  name       = var.gke_node_pool_name
  cluster    = google_container_cluster.gke.name
  # Define initial number of nodes for the pool with a lifecycle block to ignore subsequent changes to this field
  initial_node_count = 2

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  autoscaling {
      min_node_count = 2
      max_node_count = 4
  }

  node_config {
    machine_type = var.gke_node_pool_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }
    # Logging, Monitoring and Storage Access
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}
