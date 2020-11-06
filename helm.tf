resource "helm_release" "consul" {
  depends_on = [kubernetes_namespace.hashicorp]
  name       = "${var.consul_release_name}-consul"
  chart      = "${path.module}/consul-helm"
  namespace  = var.consul_k8s_namespace

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
  name      = "${var.consul_release_name}-vault"
  chart     = "${path.module}/vault-helm"
  namespace  = var.consul_k8s_namespace

  set {
    name = "server.ha.enabled"
    value = "true"
  }
  
  depends_on = [helm_release.consul]
}
