# Configure DNS for Consul
# https://www.consul.io/docs/platform/k8s/dns.html

data "kubernetes_service" "consul_dns" {
  metadata {
    name      = "${helm_release.consul.metadata[0].name}-dns"
    namespace = var.chart_namespace
  }
}

locals {
  kube_dns = {
    consul = [data.kubernetes_service.consul_dns.spec[0].cluster_ip]
  }
}

data "template_file" "consul_core_dns" {
  template = var.core_dns_template

  vars = {
    consul_dns_address = data.kubernetes_service.consul_dns.spec[0].cluster_ip
  }
}

resource "kubernetes_config_map" "consul_kube_dns" {
  count = var.configure_kube_dns ? 1 : 0

  metadata {
    labels = {
      "addonmanager.kubernetes.io/mode" = "EnsureExists"
    }

    name      = "kube-dns"
    namespace = "kube-system"
  }

  data = {
    "stubDomains" = jsonencode(local.kube_dns)
  }
}

resource "kubernetes_config_map" "consul_core_dns" {
  count = var.configure_core_dns ? 1 : 0

  metadata {
    labels = var.core_dns_labels

    name      = "coredns"
    namespace = "kube-system"
  }

  data = {
    "Corefile" = data.template_file.consul_core_dns.rendered
  }
}
