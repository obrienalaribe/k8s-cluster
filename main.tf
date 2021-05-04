# Define Terraform providers
provider "google" {
  project     = var.project
  region      = var.region
}

provider "kubernetes" {
  version = "~> 1.11"
  load_config_file = false
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  host                   = module.gke_auth.host
  token                  = module.gke_auth.token
}

provider "helm" {
  version = "~> 1.3"
  kubernetes {
      load_config_file = false
      cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
      host                   = module.gke_auth.host
      token                  = module.gke_auth.token
  }
}
