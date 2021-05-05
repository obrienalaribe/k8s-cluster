# Google Vars
variable "project" {
  type        = string
  description = "GCP Project"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "zones" {
  type        = list(string)
  description = "GCP Zones"
}

# GKE Vars
variable "gke_cluster_name" {
  type        = string
  description = "GKE cluster name"
}

variable "gke_node_pool_name" {
  type        = string
  description = "GKE manage node pool name"
}

variable "gke_node_pool_machine_type" {
  type        = string
  description = "Instance type used upon node pool creation"
}

variable "gke_initial_node_count" {
  type        = number
  description = "The initial number of nodes for the pool."
}

variable "gke_min_node_count" {
  type        = number
  description = "Minimum number of nodes in the NodePool"
}

variable "gke_max_node_count" {
  type        = number
  description = "Maximum number of nodes in the NodePool"
}

variable "gke_cluster_master_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation to use for the hosted master network"
}

variable "gke_cluster_autoscaling_max_cpu_cores" {
  type        = number
  default     = 4
  description = "Maximum amount of CPU resource in the cluster."
}

variable "gke_cluster_autoscaling_max_memory_gb" {
  type        = number
  default     = 16
  description = "Maximum amount of Memory resource in the cluster."
}

variable "gke_cluster_autoscaling_min_cpu_cores" {
  type        = number
  default     = 1
  description = "Minimum amount of CPU resource in the cluster."
}

variable "gke_cluster_autoscaling_min_memory_gb" {
  type        = number
  default     = 1
  description = "Minimum amount of Memory resource in the cluster."
}


variable "enable_kong" {
  type        = bool
  default     = true
  description = "Whether or not to deploy Kong"
}

variable "enable_rook" {
  type        = bool
  default     = true
  description = "Whether or not to deploy Rook"
}

# Hashicorp Vars
variable "enable_vault_consul" {
  type        = bool
  default     = true
  description = "Whether or not to deploy Vault and Consul"
}

variable "hashicorp_release_name" {
  type        = string
  description = "Helm Release name for Vault and Consul charts"
}

variable "hashicorp_k8s_namespace" {
  type        = string
  default     = "hashicorp"
  description = "Namespace to deploy the Helm charts"
}

# Vault Vars
variable "vault_replicas" {
  type        = number
  default     = 1
  description = "Number of vault replicas"
}

# Consul Vars
variable "consul_replicas" {
  type        = number
  default     = 1
  description = "Number of consul replicas"
}
