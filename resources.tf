# Create the GKE cluster removing the default node pool created by GKE upon cluster creation
resource "google_container_cluster" "gke" {
  name     = var.gke_cluster_name
  location = var.region
  node_locations = var.zones
  remove_default_node_pool = true
  initial_node_count       = 1
  ip_allocation_policy {} # Define block for VPC-Native Cluster
  maintenance_policy {
    recurring_window {
    start_time = "2021-03-23T00:00:00Z"
    end_time = "2021-03-23T06:00:00Z"
    recurrence = "FREQ=WEEKLY;BYDAY=SA,SU"
    }
  }
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = var.gke_cluster_master_cidr_block
  }
}

# Create the new managed default node pool with autoscaling
resource "google_container_node_pool" "default_node_pool" {
  name       = var.gke_node_pool_name
  location = var.region
  cluster    = google_container_cluster.gke.name
  # Define initial number of nodes for the pool with a lifecycle block to ignore subsequent changes to this field
  initial_node_count = var.gke_initial_node_count

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  autoscaling {
      min_node_count = var.gke_min_node_count
      max_node_count = var.gke_max_node_count
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
