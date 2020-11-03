resource "kubernetes_namespace" "hashicorp" {
  metadata {
    annotations = {
      name = var.consul_k8s_namespace
    }

    labels = {
      purpose = "consul"
    }

    name = var.consul_k8s_namespace
  }
}
