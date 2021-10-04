module "esm" {
  source = "./modules/esm"

  count = var.enable_esm ? 1 : 0

  esm_release_name     = var.esm_release_name
  esm_chart_name       = var.esm_chart_name
  esm_chart_repository = var.esm_chart_repository
  esm_chart_version    = var.esm_chart_version
  chart_namespace      = var.chart_namespace
  max_history          = var.max_history

  esm_replica = var.esm_replica
  esm_image   = var.esm_image
  esm_tag     = var.esm_tag

  esm_resources                  = var.esm_resources
  esm_affinity                   = var.esm_affinity
  esm_tolerations                = var.esm_tolerations
  esm_pod_security_context       = var.esm_pod_security_context
  esm_container_security_context = var.esm_container_security_context
  esm_pod_annotations            = var.esm_pod_annotations
  esm_env                        = var.esm_env

  esm_init_container_set_sysctl = var.esm_init_container_set_sysctl

  esm_server_address      = coalesce(var.esm_server_address, "${coalesce(var.name, var.release_name)}-server.${var.chart_namespace}.svc")
  esm_server_port         = var.esm_server_port
  tls_enabled             = var.tls_enabled
  tls_cacert              = var.tls_ca.cert
  tls_enable_auto_encrypt = var.tls_enable_auto_encrypt
  consul_k8s_image        = var.consul_k8s_image

  esm_log_level              = var.esm_log_level
  esm_service_name           = var.esm_service_name
  esm_service_tag            = var.esm_service_tag
  esm_kv_path                = var.esm_kv_path
  esm_external_node_meta     = var.esm_external_node_meta
  esm_node_reconnect_timeout = var.esm_node_reconnect_timeout
  esm_node_probe_interval    = var.esm_node_probe_interval
  esm_http_addr              = var.esm_http_addr
  esm_ping_type              = var.esm_ping_type

  esm_use_node_agent  = var.esm_use_node_agent
  esm_node_agent_port = var.esm_node_agent_port

  consul_template_image = var.consul_template_image
}
