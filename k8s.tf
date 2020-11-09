resource "kubernetes_namespace" "hashicorp" {
  metadata {
    annotations = {
      name = var.hashicorp_k8s_namespace
    }

    labels = {
      purpose = "consul"
    }

    name = var.hashicorp_k8s_namespace
  }
}
