resource "helm_release" "consul" {
  count      = var.enable_vault_consul ? 1 : 0
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
  count     = var.enable_vault_consul ? 1 : 0
  name      = "${var.hashicorp_release_name}-vault"
  chart     = "${path.module}/vault-helm"
  namespace = var.hashicorp_k8s_namespace

  set {
    name  = "server.ha.enabled"
    value = "true"
  }

  set {
    name  = "server.ha.replicas"
    value = var.vault_replicas
  }

  depends_on = [helm_release.consul]
}

resource "helm_release" "nginx_ingress" {
  count      = var.enable_nginx_ingress_controller ? 1 : 0
  depends_on = [kubernetes_namespace.nginx]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.nginx.0.id
  values = [
    <<EOF
    controller:
      service:
        loadBalancerSourceRanges:
          - 173.245.48.0/20
          - 103.21.244.0/22
          - 103.22.200.0/22
          - 103.31.4.0/22
          - 141.101.64.0/18
          - 108.162.192.0/18
          - 190.93.240.0/20
          - 188.114.96.0/20
          - 197.234.240.0/22
          - 198.41.128.0/17
          - 162.158.0.0/15
          - 172.64.0.0/13
          - 131.0.72.0/22
          - 104.16.0.0/13
          - 104.24.0.0/14
    EOF
  ]
}
