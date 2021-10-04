# Deploy Consul ESM
resource "helm_release" "consul_esm" {
  name       = var.esm_release_name
  chart      = var.esm_chart_name
  repository = var.esm_chart_repository
  version    = var.esm_chart_version
  namespace  = var.chart_namespace

  max_history = var.max_history

  values = [
    templatefile("${path.module}/templates/esm-values.yaml", local.esm_values),
  ]
}

locals {
  esm_values = {
    replica = var.esm_replica
    image   = var.esm_image
    tag     = var.esm_tag

    resources   = jsonencode(var.esm_resources)
    affinity    = jsonencode(var.esm_affinity)
    tolerations = jsonencode(var.esm_tolerations)

    pod_annotations            = jsonencode(var.esm_pod_annotations)
    pod_security_context       = jsonencode(var.esm_pod_security_context)
    container_security_context = jsonencode(var.esm_container_security_context)

    env       = jsonencode(var.esm_env)
    log_level = var.esm_log_level

    service_name = var.esm_service_name
    service_tag  = var.esm_service_tag

    kv_path = var.esm_kv_path

    external_node_meta = jsonencode(var.esm_external_node_meta)

    node_reconnect_timeout = var.esm_node_reconnect_timeout
    node_probe_interval    = var.esm_node_probe_interval
    http_addr              = var.esm_http_addr
    ping_type              = var.esm_ping_type

    use_node_agent  = var.esm_use_node_agent
    node_agent_port = coalesce(var.esm_node_agent_port, var.tls_enabled ? 8501 : 8500)

    tls_enabled = var.tls_enabled
    tls_cacert  = var.tls_cacert != null ? jsonencode(var.tls_cacert) : "null"

    tls_enable_auto_encrypt = var.tls_enable_auto_encrypt
    consul_k8s_image        = "${var.consul_k8s_image}:${var.consul_k8s_tag}"
    consul_template_image   = var.consul_template_image
    server_address          = var.esm_server_address
    server_port             = coalesce(8501, var.esm_server_port)

    init_container_set_sysctl = var.esm_init_container_set_sysctl
  }
}
