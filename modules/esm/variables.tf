variable "tls_enabled" {
  description = "Enable TLS for the Consul cluster"
  type        = bool
  default     = false
}

variable "tls_cacert" {
  description = "Self generated CA for Consul Server TLS. Values should be PEM encoded"
  type        = string
  default     = null
}

variable "tls_enable_auto_encrypt" {
  description = "Enable auto encrypt. Uses the connect CA to distribute certificates to clients"
  type        = bool
  default     = false
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

variable "esm_server_address" {
  description = "Address for Consul Server"
  type        = string
  default     = "consul-server.svc"
}

variable "max_history" {
  description = "Max History for Helm"
  type        = number
  default     = 20
}

variable "chart_namespace" {
  description = "Namespace to install the chart into"
  type        = string
  default     = "default"
}

################################
# Consul ESM
################################
variable "esm_release_name" {
  description = "Name of the ESM Chart Release"
  type        = string
  default     = "consul-esm"
}

variable "esm_chart_name" {
  description = "Name of the ESM Chart name"
  type        = string
  default     = "consul-esm"
}

variable "esm_chart_repository" {
  description = "ESM Chart repository"
  type        = string
  default     = "https://basisai.github.io/charts/"
}

variable "esm_chart_version" {
  description = "ESM Chart version"
  type        = string
  default     = "0.3.1"
}

variable "esm_replica" {
  description = "Number of ESM replica"
  type        = number
  default     = 3
}

variable "esm_image" {
  description = "Docker image for ESM"
  type        = string
  default     = "hashicorp/consul-esm"
}

variable "esm_tag" {
  description = "Docker Image tag for ESM"
  type        = string
  default     = "0.6.0"
}

variable "esm_resources" {
  description = "Resources for ESM"
  type        = any
  default = {
    requests = {
      cpu = "200m"
    }
    limits = {
      memory = "256Mi"
    }
  }
}

variable "esm_affinity" {
  description = "Affinity for ESM"
  type        = any
  default     = {}
}

variable "esm_tolerations" {
  description = "Toleration for ESM"
  type        = any
  default     = []
}

variable "esm_pod_security_context" {
  description = "securityContext for ESM pods"
  type        = any
  default     = {}
}

variable "esm_container_security_context" {
  description = "securityContext for ESM containers"
  type        = any
  default     = {}
}

variable "esm_pod_annotations" {
  description = "Annotations for Consul ESM Pods"
  type        = map(string)
  default     = {}
}

variable "esm_log_level" {
  description = "Log level for ESM"
  type        = string
  default     = "INFO"
}

variable "esm_service_name" {
  description = "ESM service name in Consul"
  type        = string
  default     = "consul-esm"
}

variable "esm_service_tag" {
  description = "Service tag for ESM"
  type        = string
  default     = ""
}

variable "esm_kv_path" {
  description = "The directory in the Consul KV store to use for storing ESM runtime data."
  type        = string
  default     = "consul-esm/"
}

variable "esm_external_node_meta" {
  description = "The node metadata values used for the ESM to qualify a node in the catalog as an \"external node\"."
  type        = map(string)
  default = {
    "external-node" = "true"
  }
}

variable "esm_node_reconnect_timeout" {
  description = "The length of time to wait before reaping an external node due to failed pings."
  type        = string
  default     = "72h"
}

variable "esm_node_probe_interval" {
  description = "The interval to ping and update coordinates for external nodes that have 'external-probe' set to true. By default, ESM will attempt to ping and  update the coordinates for all nodes it is watching every 10 seconds."
  type        = string
  default     = "10s"
}

variable "esm_http_addr" {
  description = "HTTP address of the local Consul agent"
  type        = string
  default     = ""
}

variable "esm_ping_type" {
  description = "The method to use for pinging external nodes."
  type        = string
  default     = "udp"
}

variable "esm_env" {
  description = "Environment variables for Consul ESM"
  type        = any
  default     = []
}

variable "esm_init_container_set_sysctl" {
  description = "Enable setting sysctl settings via a privileged container to allow pings"
  type        = bool
  default     = false
}

variable "esm_use_node_agent" {
  description = "Use Consul agent Daemonset"
  type        = bool
  default     = true
}

variable "esm_node_agent_port" {
  description = "Override port for Consul agent Daemonset"
  type        = number
  default     = null
}

variable "consul_template_image" {
  description = "Image for Consul Template"
  type        = string
  default     = "hashicorp/consul-template:0.26.0"
}

variable "esm_server_port" {
  description = "Override Consul Server port for TLS when using Auto Encrypt"
  type        = number
  default     = null
}
