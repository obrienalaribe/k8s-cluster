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

resource "kubernetes_namespace" "nginx" {
  count = var.enable_nginx_ingress_controller ? 1 : 0
  metadata {
    annotations = {
      name = "nginx"
    }

    labels = {
      purpose = "nginx-ingress-controller"
    }

    name = "nginx"
  }
}
