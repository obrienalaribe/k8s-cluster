# Google Vars
variable "project" {
  type = string
  description = "GCP Project"
}

variable "region" {
  type = string
  description = "GCP Region"
}

variable "zone" {
  type = string
  description = "GCP Zone"
}

# GKE Vars
variable "gke_cluster_name" {
  type = string
  description = "GKE cluster name"
}

variable "gke_node_pool_name" {
  type = string
  description = "GKE manage node pool name"
}

variable "gke_node_pool_machine_type" {
  type = string
  description = "Instance type used upon node pool creation"
}

variable "enable_kong" {
  type = bool
  default = true
  description = "Whether or not to deploy Kong"
}

# Hashicorp Vars
variable "enable_vault_consul" {
  type = bool
  default = true
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
