# Define Terraform providers
provider "google" {
  project     = var.project
  region      = var.region
  zone        = var.zone
}

provider "kubernetes" {
  version = "~> 1.11"
  config_path = abspath(local_file.kubeconfig.filename)
}

provider "helm" {
  version = "~> 1.3"
  kubernetes {
    config_path = abspath(local_file.kubeconfig.filename)
  }
}
