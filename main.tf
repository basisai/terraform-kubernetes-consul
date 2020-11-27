resource "helm_release" "consul" {
  name       = var.release_name
  chart      = var.chart_name
  repository = var.chart_repository
  version    = var.chart_version
  namespace  = var.chart_namespace

  max_history = var.max_history
  timeout     = var.chart_timeout

  values = [
    templatefile("${path.module}/templates/values.yaml", local.consul_values),
  ]
}

locals {
  consul_values = {
    name        = var.name != null ? jsonencode(var.name) : "null"
    image       = "${var.consul_image_name}:${var.consul_image_tag}"
    image_k8s   = "${var.consul_k8s_image}:${var.consul_k8s_tag}"
    image_envoy = var.image_envoy

    pod_security_policy_enable = var.pod_security_policy_enable

    datacenter = var.server_datacenter

    gossip_secret = var.gossip_encryption_key != null ? kubernetes_secret.secrets.metadata[0].name : "null"
    gossip_key    = var.gossip_encryption_key != null ? "gossip" : "null"

    consul_domain         = var.consul_domain
    server_replicas       = var.server_replicas
    server_storage        = var.server_storage
    server_storage_class  = var.server_storage_class
    server_resources      = yamlencode(var.server_resources)
    server_extra_config   = jsonencode(jsonencode(var.server_extra_config))
    server_extra_volumes  = jsonencode(var.server_extra_volumes)
    server_affinity       = jsonencode(var.server_affinity)
    server_tolerations    = jsonencode(var.server_tolerations)
    server_priority_class = var.server_priority_class
    server_annotations    = jsonencode(var.server_annotations)

    client_enabled        = jsonencode(var.client_enabled)
    client_grpc           = var.client_grpc
    client_resources      = yamlencode(var.client_resources)
    client_extra_config   = jsonencode(jsonencode(var.client_extra_config))
    client_extra_volumes  = jsonencode(var.client_extra_volumes)
    client_tolerations    = jsonencode(var.client_tolerations)
    client_priority_class = var.client_priority_class
    client_annotations    = jsonencode(var.client_annotations)

    tls_enabled                    = var.tls_enabled
    tls_server_additional_dns_sans = jsonencode(var.tls_server_additional_dns_sans)
    tls_server_additional_ip_sans  = jsonencode(var.tls_server_additional_ip_sans)
    tls_verify                     = var.tls_verify
    tls_https_only                 = var.tls_https_only
    tls_enable_auto_encrypt        = jsonencode(var.tls_enable_auto_encrypt)

    tls_cacert_secret_name = var.tls_ca != null ? kubernetes_secret.secrets.metadata[0].name : "null"
    tls_cacert_secret_key  = var.tls_ca != null ? "cacert" : "null"
    tls_cakey_secret_name  = var.tls_ca != null ? kubernetes_secret.secrets.metadata[0].name : "null"
    tls_cakey_secret_key   = var.tls_ca != null ? "cakey" : "null"

    enable_sync_catalog           = jsonencode(var.enable_sync_catalog)
    sync_by_default               = var.sync_by_default
    sync_to_consul                = var.sync_to_consul
    sync_to_k8s                   = var.sync_to_k8s
    sync_k8s_prefix               = var.sync_k8s_prefix
    sync_k8s_tag                  = var.sync_k8s_tag
    sync_cluster_ip_services      = var.sync_cluster_ip_services
    sync_node_port_type           = var.sync_node_port_type
    sync_add_k8s_namespace_suffix = var.sync_add_k8s_namespace_suffix
    sync_affinity                 = jsonencode(var.sync_affinity)
    sync_tolerations              = jsonencode(var.sync_tolerations)
    sync_resources                = yamlencode(var.sync_resources)
    sync_priority_class           = var.sync_priority_class

    enable_ui          = jsonencode(var.enable_ui)
    ui_service_type    = var.ui_service_type
    ui_annotations     = jsonencode(var.ui_annotations)
    ui_additional_spec = jsonencode(var.ui_additional_spec)

    connect_enable                = jsonencode(var.connect_enable)
    enable_connect_inject         = var.enable_connect_inject
    connect_inject_by_default     = var.connect_inject_by_default
    connect_inject_affinity       = jsonencode(var.connect_inject_affinity)
    connect_inject_tolerations    = jsonencode(var.connect_inject_tolerations)
    connect_inject_resources      = jsonencode(var.connect_inject_resources)
    connect_inject_priority_class = var.connect_inject_priority_class

    connect_inject_namespace_selector = var.connect_inject_namespace_selector != null ? var.connect_inject_namespace_selector : "null"
    connect_inject_allowed_namespaces = jsonencode(var.connect_inject_allowed_namespaces)
    connect_inject_denied_namespaces  = jsonencode(var.connect_inject_denied_namespaces)
    connect_inject_default_protocol   = var.connect_inject_default_protocol != null ? var.connect_inject_default_protocol : "null"
    connect_inject_log_level          = var.connect_inject_log_level

    connect_inject_sidecar_proxy_resources = yamlencode(var.connect_inject_sidecar_proxy_resources)
    connect_inject_init_resources          = yamlencode(var.connect_inject_init_resources)
    lifecycle_sidecar_container_resources  = yamlencode(var.lifecycle_sidecar_container_resources)
    envoy_extra_args                       = var.envoy_extra_args != null ? jsonencode(var.envoy_extra_args) : "null"

    inject_health_check                  = var.inject_health_check
    inject_health_check_reconcile_period = var.inject_health_check_reconcile_period

    controller_enable           = var.controller_enable
    controller_log_level        = var.controller_log_level
    controller_resources        = yamlencode(var.controller_resources)
    controller_node_selector    = var.controller_node_selector != null ? jsonencode(var.controller_node_selector) : "null"
    controller_node_tolerations = var.controller_node_tolerations != null ? jsonencode(var.controller_node_tolerations) : "null"
    controller_node_affinity    = var.controller_node_affinity != null ? jsonencode(var.controller_node_affinity) : "null"
    controller_priority_class   = var.controller_priority_class

    terminating_gateway_enable   = var.terminating_gateway_enable
    terminating_gateway_defaults = yamlencode(var.terminating_gateway_defaults)
    terminating_gateways         = yamlencode(var.terminating_gateways)
  }
}

resource "kubernetes_secret" "secrets" {
  metadata {
    name        = var.secret_name
    annotations = var.secret_annotation
    namespace   = var.chart_namespace
  }

  type = "Opaque"

  data = {
    gossip = var.gossip_encryption_key != null ? var.gossip_encryption_key : ""
    cacert = var.tls_ca != null ? var.tls_ca.cert : ""
    cakey  = var.tls_ca != null ? var.tls_ca.key : ""
  }
}
