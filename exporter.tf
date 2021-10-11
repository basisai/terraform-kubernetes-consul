# Deploy Consul Exporter for Prometheus
module "prometheus_exporter" {
  count      = var.enable_exporter ? 1 : 0
  depends_on = [helm_release.consul]

  source = "./modules/prometheus_exporter"

  consul_server_address   = coalesce(var.esm_server_address, "${coalesce(var.name, var.release_name)}-server.${var.chart_namespace}.svc")
  tls_enabled             = var.tls_enabled
  tls_cacert              = var.tls_ca.cert
  tls_enable_auto_encrypt = var.tls_enable_auto_encrypt
  consul_k8s_image        = var.consul_k8s_image
  consul_template_image   = var.consul_template_image

  exporter_release_name     = var.exporter_release_name
  exporter_chart_name       = var.exporter_chart_name
  exporter_chart_repository = var.exporter_chart_repository
  exporter_chart_version    = var.exporter_chart_version
  chart_namespace           = var.chart_namespace
  max_history               = var.max_history

  exporter_replica = var.exporter_replica
  exporter_image   = var.exporter_image
  exporter_tag     = var.exporter_tag

  exporter_resources   = var.exporter_resources
  exporter_affinity    = var.exporter_affinity
  exporter_tolerations = var.exporter_tolerations

  exporter_service_annotations = var.exporter_service_annotations

  exporter_rbac_enabled = var.exporter_rbac_enabled
  exporter_psp          = var.exporter_psp

  exporter_service_monitor = var.exporter_service_monitor

  exporter_options = var.exporter_options
  exporter_env     = var.exporter_env

  exporter_extra_volumes       = var.exporter_extra_volumes
  exporter_extra_volume_mounts = var.exporter_extra_volume_mounts
  exporter_init_containers     = var.exporter_init_containers
  exporter_extra_containers    = var.exporter_extra_containers
  exporter_pod_annotations     = var.exporter_pod_annotations
}
