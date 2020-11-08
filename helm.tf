resource "helm_release" "consul" {
  depends_on = [kubernetes_namespace.hashicorp]
  name       = "${var.hashicorp_release_name}-consul"
  chart      = "${path.module}/consul-helm"
  namespace  = var.hashicorp_k8s_namespace

  set {
    name  = "global.name"
    value = "consul"
  }

  set {
    name  = "server.replicas"
    value = var.consul_replicas
  }

  set {
    name  = "server.bootstrapExpect"
    value = var.consul_replicas
  }
}

resource "helm_release" "vault" {
  name      = "${var.hashicorp_release_name}-vault"
  chart     = "${path.module}/vault-helm"
  namespace  = var.hashicorp_k8s_namespace

  set {
    name = "server.ha.enabled"
    value = "true"
  }

  set {
    name  = "server.ha.replicas"
    value = var.consul_replicas
  }
  
  depends_on = [helm_release.consul]
}
