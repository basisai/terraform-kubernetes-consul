variable "tls_enabled" {
  description = "Enable TLS for the Consul cluster"
  type        = bool
  default     = false
}

variable "tls_enable_auto_encrypt" {
  description = "Enable auto encrypt. Uses the connect CA to distribute certificates to clients"
  type        = bool
  default     = false
}

variable "tls_cacert" {
  description = "Self generated CA for Consul Server TLS. Values should be PEM encoded"
  type        = string
  default     = null
}

variable "consul_k8s_image" {
  description = "Docker image of the consul-k8s binary to run"
  type        = string
  default     = "hashicorp/consul-k8s-control-plane"
}

variable "consul_k8s_tag" {
  description = "Image tag of the consul-k8s binary to run"
  type        = string
  default     = "0.34.1"
}

variable "consul_server_address" {
  description = "Address for Consul Server"
  type        = string
  default     = "consul-server.svc"
}

variable "consul_template_image" {
  description = "Image for Consul Template"
  type        = string
  default     = "hashicorp/consul-template:0.26.0"
}

variable "chart_namespace" {
  description = "Namespace to install the chart into"
  type        = string
  default     = "default"
}

variable "max_history" {
  description = "Max History for Helm"
  type        = number
  default     = 20
}

#################################
# Consul Exporter for Prometheus
#################################
variable "exporter_release_name" {
  description = "Name of the Consul Exporter Chart Release"
  default     = "consul-exporter"
}

variable "exporter_chart_name" {
  description = "Name of the Consul Exporter Chart name"
  default     = "prometheus-consul-exporter"
}

variable "exporter_chart_repository" {
  description = "Consul Exporter Chart repository"
  default     = "https://prometheus-community.github.io/helm-charts"
}

variable "exporter_chart_version" {
  description = "Consul Exporter Chart version"
  default     = "0.4.0"
}

variable "exporter_replica" {
  description = "Number of Consul Exporter replicas"
  default     = 1
}

variable "exporter_image" {
  description = "Docker image for Consul Exporter"
  default     = "prom/consul-exporter"
}

variable "exporter_tag" {
  description = "Docker Image tag for Consul Exporter"
  default     = "v0.7.1"
}

variable "exporter_resources" {
  description = "Resources for Consul Exporter"

  default = {
    requests = {
      cpu = "200m"
    }
    limits = {
      memory = "256Mi"
    }
  }
}

variable "exporter_affinity" {
  description = "Affinity for Consul Exporter"
  default     = {}
}

variable "exporter_tolerations" {
  description = "Tolerations for Consul Exporter"
  default     = []
}

variable "exporter_service_annotations" {
  description = "Consul Exporter service's annotations"
  default     = {}
}

variable "exporter_rbac_enabled" {
  description = "Create RBAC resources for Exporter"
  default     = true
}

variable "exporter_psp" {
  description = "Create PSP resources for Exporter"
  default     = true
}

variable "exporter_service_monitor" {
  description = "Create a ServiceMonitor to configure scraping"
  default     = false
}

variable "exporter_options" {
  description = "Arguments for Exporter. See https://github.com/prometheus/consul_exporter#flags"
  default     = {}
}

variable "exporter_env" {
  description = "Additional Environment Variables for Exporter"
  default     = []
}

variable "exporter_extra_volumes" {
  description = "Extra volumes for Exporter"
  default     = []
}

variable "exporter_extra_volume_mounts" {
  description = "Extra volume mounts for Exporter"
  default     = []
}

variable "exporter_init_containers" {
  description = "Extra Init Containers"
  default     = []
}

variable "exporter_extra_containers" {
  description = "Extra extra Containers"
  default     = []
}

variable "exporter_pod_annotations" {
  description = "Annotations for Exporter Pods"
  type        = map(string)
  default     = {}
}
