variable "release_name" {
  description = "Helm release name for Consul"
  default     = "consul"
}

variable "chart_name" {
  description = "Helm chart name to provision"
  default     = "consul"
}

variable "chart_repository" {
  description = "Helm repository for the chart"
  default     = "https://helm.releases.hashicorp.com"
}

variable "chart_version" {
  description = "Version of Chart to install. Set to empty to install the latest version"
  default     = "0.39.0"
}

variable "chart_namespace" {
  description = "Namespace to install the chart into"
  default     = "default"
}

variable "chart_timeout" {
  description = "Timeout to wait for the Chart to be deployed. The chart waits for all Daemonset pods to be healthy before ending. Increase this for larger clusers to avoid timeout"
  default     = 1800
}

variable "name" {
  description = "Sets the prefix used for all resources in the helm chart. If not set, the prefix will be \"<helm release name>-consul\"."
  default     = null
}

variable "fullname_override" {
  description = "Fullname Override of Helm resources"
  default     = ""
}

variable "log_json_enable" {
  description = "Enable all component logs to be output in JSON format"
  default     = false
}

variable "max_history" {
  description = "Max History for Helm"
  default     = 20
}

variable "consul_image_name" {
  description = "Docker Image of Consul to run"
  default     = "consul"
}

variable "consul_image_tag" {
  description = "Docker image tag of Consul to run"
  default     = "1.11.1"
}

variable "consul_k8s_image" {
  description = "Docker image of the consul-k8s binary to run"
  default     = "hashicorp/consul-k8s-control-plane"
}

variable "consul_k8s_tag" {
  description = "Image tag of the consul-k8s binary to run"
  default     = "0.36.0"
}

variable "image_envoy" {
  description = "Image and tag for Envoy Docker image to use for sidecar proxies, mesh, terminating and ingress gateways"
  default     = "envoyproxy/envoy-alpine:v1.20.0"
}

variable "consul_domain" {
  description = "Top level Consul domain for DNS queries"
  default     = "consul"
}

variable "pod_security_policy_enable" {
  description = "Create PodSecurityPolicy Resources"
  default     = true
}

variable "server_replicas" {
  description = "Number of server replicas to run"
  default     = 5
}

variable "server_datacenter" {
  description = "Datacenter to configure Consul as."
}

variable "server_storage" {
  description = "This defines the disk size for configuring the servers' StatefulSet storage. For dynamically provisioned storage classes, this is the desired size. For manually defined persistent volumes, this should be set to the disk size of the attached volume."
  default     = "10Gi"
}

variable "server_storage_class" {
  description = "The StorageClass to use for the servers' StatefulSet storage. It must be able to be dynamically provisioned if you want the storage to be automatically created. For example, to use Local storage classes, the PersistentVolumeClaims would need to be manually created. An empty value will use the Kubernetes cluster's default StorageClass."
  default     = ""
}

variable "server_resources" {
  description = "Resources for server"
  default = {
    requests = {
      cpu    = "100m"
      memory = "100Mi"
    }

    limits = {
      cpu    = "100m"
      memory = "100Mi"
    }
  }
}

variable "server_update_partition" {
  description = "This value is used to carefully control a rolling update of Consul server agents. This value specifies the partition (https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions) for performing a rolling update. Please read the linked Kubernetes documentation and https://www.consul.io/docs/k8s/upgrade#upgrading-consul-servers for more information."
  default     = 0
}

variable "server_security_context" {
  description = "Security context for server pods"
  default = {
    runAsNonRoot = true
    runAsGroup   = 1000
    runAsUser    = 100
    fsGroup      = 1000
  }
}

variable "server_extra_config" {
  description = "Additional configuration to include for servers in JSON/HCL"
  default     = {}
}

variable "server_extra_volumes" {
  description = "List of map of extra volumes specification for server pods. See https://www.consul.io/docs/platform/k8s/helm.html#v-server-extravolumes for the keys"
  default     = []
}

variable "server_affinity" {
  description = "A YAML string that can be templated via helm specifying the affinity for server pods"

  default = <<EOF
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels:
          app: {{ template "consul.name" . }}
          release: "{{ .Release.Name }}"
          component: server
      topologyKey: kubernetes.io/hostname
EOF

}

variable "server_tolerations" {
  description = "A YAML string that can be templated via helm specifying the tolerations for server pods"
  default     = ""
}

variable "server_topology_spread_constraints" {
  description = "YAML string for topology spread constraints for server pods"
  type        = string
  default     = ""
}

variable "client_affinity" {
  description = "affinity Settings for Client pods, formatted as a multi-line YAML string."
  default     = null
}

variable "server_priority_class" {
  description = "Priority class for servers"
  default     = ""
}

variable "server_annotations" {
  description = "A YAML string for server pods"
  default     = ""
}

variable "server_service_account_annotations" {
  description = "YAML string for annotations for server service account"
  type        = string
  default     = ""
}

variable "client_enabled" {
  description = "Enable running Consul client agents on every Kubernetes node"
  default     = "-"
}

variable "client_grpc" {
  description = "Enable GRPC port for clients. Required for Connect Inject"
  default     = true
}

variable "client_resources" {
  description = "Resources for clients"
  default = {
    requests = {
      cpu    = "100m"
      memory = "100Mi"
    }

    limits = {
      cpu    = "100m"
      memory = "100Mi"
    }
  }
}

variable "client_extra_config" {
  description = "Additional configuration to include for client agents"
  default     = {}
}

variable "client_security_context" {
  description = "Pod security context for client pods"
  default = {
    runAsNonRoot = true
    runAsGroup   = 1000
    runAsUser    = 100
    fsGroup      = 1000
  }
}

variable "client_extra_volumes" {
  description = "List of map of extra volumes specification. See https://www.consul.io/docs/platform/k8s/helm.html#v-client-extravolumes for the keys"
  default     = []
}

variable "client_tolerations" {
  description = "A YAML string that can be templated via helm specifying the tolerations for client pods"
  default     = ""
}

variable "client_annotations" {
  description = "A YAML string for client pods"
  default     = ""
}

variable "client_labels" {
  description = "Additional labels for client pods"
  default     = {}
}

variable "client_service_account_annotations" {
  description = "YAML string for annotations for client service account"
  type        = string
  default     = ""
}

variable "client_priority_class" {
  description = "Priority class for clients"
  default     = ""
}

variable "enable_sync_catalog" {
  description = "Enable Service catalog sync: https://www.consul.io/docs/platform/k8s/service-sync.html"
  default     = true
}

variable "sync_by_default" {
  description = "If true, all valid services in K8S are synced by default. If false, the service must be annotated properly to sync. In either case an annotation can override the default."
  default     = true
}

variable "sync_to_consul" {
  description = "If true, will sync Kubernetes services to Consul. This can be disabled to have a one-way sync."
  default     = true
}

variable "sync_to_k8s" {
  description = " If true, will sync Consul services to Kubernetes. This can be disabled to have a one-way sync."
  default     = true
}

variable "sync_k8s_prefix" {
  description = " A prefix to prepend to all services registered in Kubernetes from Consul. This defaults to '' where no prefix is prepended; Consul services are synced with the same name to Kubernetes. (Consul -> Kubernetes sync only)"
  default     = ""
}

variable "sync_k8s_tag" {
  description = "An optional tag that is applied to all of the Kubernetes services that are synced into Consul. If nothing is set, this defaults to 'k8s'. (Kubernetes -> Consul sync only)"
  default     = "k8s"
}

variable "sync_cluster_ip_services" {
  description = "If true, will sync Kubernetes ClusterIP services to Consul. This can be disabled to have the sync ignore ClusterIP-type services."
  default     = true
}

variable "sync_node_port_type" {
  description = "Configures the type of syncing that happens for NodePort services. The only valid options are: ExternalOnly, InternalOnly, and ExternalFirst. ExternalOnly will only use a node's ExternalIP address for the sync, otherwise the service will not be synced. InternalOnly uses the node's InternalIP address. ExternalFirst will preferentially use the node's ExternalIP address, but if it doesn't exist, it will use the node's InternalIP address instead."
  default     = ""
}

variable "sync_add_k8s_namespace_suffix" {
  description = "Appends Kubernetes namespace suffix to each service name synced to Consul, separated by a dash."
  default     = true
}

variable "sync_affinity" {
  description = "YAML template string for Sync Catalog affinity"
  default     = ""
}

variable "sync_resources" {
  description = "Sync Catalog resources"
  default = {
    requests = {
      cpu    = "50m"
      memory = "50Mi"
    }
    limits = {
      cpu    = "50m"
      memory = "50Mi"
    }
  }
}

variable "sync_tolerations" {
  description = "Template string for Sync Catalog Tolerations"
  default     = ""
}

variable "sync_service_account_annotations" {
  description = "YAML string for annotations for sync catalog service account"
  type        = string
  default     = ""
}

variable "sync_priority_class" {
  description = "Priority Class Name for Consul Sync Catalog"
  default     = ""
}

variable "sync_acl_token" {
  description = "Secret containing ACL token if ACL is enabled and manage_system_acls is not enabled"
  type = object({
    secret_name = string
    secret_key  = string
  })
  default = {
    secret_name = null
    secret_key  = null
  }
}

variable "enable_ui" {
  description = "Enable Consul UI"
  default     = false
}

variable "ui_service_type" {
  description = "Type of service for Consul UI"
  default     = "ClusterIP"
}

variable "ui_annotations" {
  description = "UI service annotations"
  default     = ""
}

variable "ui_additional_spec" {
  description = "Additional Spec for the UI service"
  default     = ""
}

variable "configure_kube_dns" {
  description = "Configure kube-dns and OVERWRITE it to resolve .consul domains with Consul DNS"
  default     = false
}

variable "configure_core_dns" {
  description = "Configure core-dns and OVERWRITE it to resolve .consul domains with Consul DNS"
  default     = false
}

variable "core_dns_template" {
  description = "Template for CoreDNS `CoreFile` configuration. Use Terraform string interpolation format with the variable `consul_dns_address` for Consul DNS endpoint. See Default for an example"

  default = <<-EOF
    .:53 {
      errors
      health
      kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
      }
      prometheus :9153
      forward . /etc/resolv.conf
      cache 30
      loop
      reload
      loadbalance
    }

    consul {
      errors
      cache 30
      forward . $${consul_dns_address}
    }
    EOF
}

variable "core_dns_labels" {
  description = "Labels for CoreDNS ConfigMap"
  default = {
    "eks.amazonaws.com/component"     = "coredns"
    "k8s-app"                         = "kube-dns"
    "addonmanager.kubernetes.io/mode" = "EnsureExists"
  }
}

variable "consul_recursors" {
  description = "A list of addresses of upstream DNS servers that are used to recursively resolve DNS queries."
  type        = list(string)
  default     = []
}

variable "additional_chart_values" {
  description = "Additional values for the Consul Helm Chart in YAML"
  type        = list(string)
  default     = []
}

###########################
# ACL
###########################
variable "manage_system_acls" {
  description = "Manager ACL Tokens for Consul and consul-k8s components"
  type        = bool
  default     = false
}

variable "acl_bootstrap_token" {
  description = "Use an existing bootstrap token and the consul-k8s will not bootstrap anything"
  type = object({
    secret_name = string
    secret_key  = string
  })
  default = {
    secret_name = null
    secret_key  = null
  }
}

variable "create_replication_token" {
  description = "If true, an ACL token will be created that can be used in secondary datacenters for replication. This should only be set to true in the primary datacenter since the replication token must be created from that datacenter. In secondary datacenters, the secret needs to be imported from the primary datacenter"
  type        = bool
  default     = false
}

variable "replication_token" {
  description = "A secret containing the replication ACL token."
  type = object({
    secret_name = string
    secret_key  = string
  })
  default = {
    secret_name = null
    secret_key  = null
  }
}

###########################
# Consul Connect
###########################
variable "connect_enable" {
  description = "Enable consul connect. When enabled, the bootstrap will configure a default CA which can be tweaked using the Consul API later"
  default     = false
}

variable "enable_connect_inject" {
  description = "Enable Connect Injector process"
  default     = false
}

variable "connect_inject_replicas" {
  description = "Number of replicas for Connect Inject deployment"
  type        = number
  default     = 2
}

variable "connect_inject_by_default" {
  description = "If true, the injector will inject the Connect sidecar into all pods by default. Otherwise, pods must specify the injection annotation to opt-in to Connect injection. If this is true, pods can use the same annotation to explicitly opt-out of injection."
  default     = false
}

variable "connect_inject_namespace_selector" {
  description = "A YAML string selector for restricting injection to only matching namespaces. By default all namespaces except the system namespace will have injection enabled."
  default     = <<-EOF
    matchExpressions:
      - key: "kubernetes.io/metadata.name"
        operator: "NotIn"
        values: ["kube-system","local-path-storage"]
    EOF
}

variable "connect_inject_allowed_namespaces" {
  description = "List of allowed namespaces to inject. "
  default     = ["*"]
}

variable "connect_inject_denied_namespaces" {
  description = "List of denied namespaces to inject. "
  default     = []
}

variable "connect_inject_affinity" {
  description = "Template string for Connect Inject Affinity"
  default     = ""
}

variable "connect_inject_tolerations" {
  description = "Template string for Connect Inject Tolerations"
  default     = ""
}

variable "connect_inject_resources" {
  description = "Resources for connect inject pod"
  default = {
    requests = {
      cpu    = "50m"
      memory = "50Mi"
    }
    limits = {
      cpu    = "50m"
      memory = "50Mi"
    }
  }
}

variable "connect_inject_priority_class" {
  description = "Pod Priority Class for Connect Inject"
  default     = ""
}

variable "connect_inject_log_level" {
  description = "Log verbosity level. One of debug, info, warn, or error."
  default     = ""
}

variable "connect_inject_failure_policy" {
  description = <<-EOF
  Sets the failurePolicy for the mutating webhook. By default this will cause pods not part of the consul installation to fail scheduling while the webhook
  is offline. This prevents a pod from skipping mutation if the webhook were to be momentarily offline.
  Once the webhook is back online the pod will be scheduled.
  In some environments such as Kind this may have an undesirable effect as it may prevent volume provisioner pods from running
  which can lead to hangs. In these environments it is recommend to use "Ignore" instead.
  This setting can be safely disabled by setting to "Ignore".
  EOF

  type    = string
  default = "Fail"
}

variable "connect_inject_sidecar_proxy_resources" {
  description = "Set default resources for sidecar proxy. If null, that resource won't be set."
  default = {
    requests = {
      cpu    = "100m"
      memory = "100Mi"
    }
    limits = {
      cpu    = "100m"
      memory = "100Mi"
    }
  }
}

variable "connect_inject_init_resources" {
  description = "Resource settings for the Connect injected init container."
  default = {
    requests = {
      cpu    = "50m"
      memory = "50Mi"
    }
    limits = {
      cpu    = "50m"
      memory = "50Mi"
    }
  }
}

variable "consul_sidecar_container_resources" {
  description = <<-EOF
    Resource settings for consul -sidecar containers.
    The consul  sidecar ensures the Consul services are always registered with
    their local consul clients and is used by the ingress/terminating/mesh gateways
    as well as with every connect-injected service.
    EOF
  default = {
    requests = {
      cpu    = "20m"
      memory = "50Mi"
    }
    limits = {
      cpu    = "20m"
      memory = "50Mi"
    }
  }
}

variable "envoy_extra_args" {
  description = "Pass arguments to the injected envoy sidecar. Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli"
  default     = null
}

variable "connect_inject_acl_binding_rule_selector" {
  description = <<-EOF
    Query that defines which Service Accounts
    can authenticate to Consul and receive an ACL token during Connect injection.
    The default setting, i.e. serviceaccount.name!=default, prevents the
    'default' Service Account from logging in.
    If set to an empty string all service accounts can log in.
    This only has effect if ACLs are enabled.

    See https://www.consul.io/docs/acl/acl-auth-methods.html#binding-rules
    and https://www.consul.io/docs/acl/auth-methods/kubernetes.html#trusted-identity-attributes
    for more details.
    EOF
  type        = string
  default     = "serviceaccount.name!=default"
}

variable "connect_inject_override_auth_method_name" {
  description = "If you are not using global.acls.manageSystemACLs and instead manually setting up an auth method for Connect inject, set this to the name of your auth method."
  type        = string
  default     = ""
}

variable "connect_inject_acl_token" {
  description = "Secret containing ACL token if ACL is enabled and manage_system_acls is not enabled"
  type = object({
    secret_name = string
    secret_key  = string
  })
  default = {
    secret_name = null
    secret_key  = null
  }
}

###########################
# Transparent Proxy
###########################
variable "transparent_proxy_default_enabled" {
  description = "Enable transparent proxy by default on all connect injected pods"
  type        = bool
  default     = true
}

variable "transparent_proxy_default_overwrite_probes" {
  description = "Overwrite HTTP probes by default when transparent proxy is in use"
  type        = bool
  default     = true
}

###########################
# Consul Configuration Entries CRD Controller
###########################
variable "controller_enable" {
  description = "Enable Consul Configuration Entries CRD Controller"
  default     = false
}

variable "controller_replicas" {
  description = "Number of replicas for the CRD controller"
  type        = number
  default     = 1
}

variable "controller_log_level" {
  description = "CRD Controller Log level."
  default     = ""
}

variable "controller_resources" {
  description = "CRD Controller resources"
  default = {
    requests = {
      cpu    = "100m"
      memory = "50Mi"
    }
    limits = {
      cpu    = "100m"
      memory = "50Mi"
    }
  }
}

variable "controller_node_selector" {
  description = "YAML string for Controller Node Selector"
  default     = null
}

variable "controller_node_tolerations" {
  description = "YAML string for Controller tolerations"
  default     = null
}

variable "controller_node_affinity" {
  description = "YAML string for Controller affinity"
  default     = null
}

variable "controller_priority_class" {
  description = "Priority class for Controller pods"
  default     = ""
}

variable "controller_service_account_annotations" {
  description = "YAML string with annotations for CRD Controller service account"
  type        = string
  default     = ""
}

variable "controller_acl_token" {
  description = "Secret containing ACL token if ACL is enabled and manage_system_acls is not enabled"
  type = object({
    secret_name = string
    secret_key  = string
  })
  default = {
    secret_name = null
    secret_key  = null
  }
}

###########################
# Consul Connect Terminating Gateway
###########################
variable "terminating_gateway_enable" {
  description = "Deploy Terminating Gateways"
  type        = bool
  default     = false
}

variable "terminating_gateway_defaults" {
  description = <<-EOF
    Terminating Gateway defaults.
    You can override any of these fields under `terminating_gateways`.
    Annotations are concatenated

    Note: You do not have to specify all of the fields to override them. If you omit them, they will
    fall back to the defaults for the Helm Chart.
  EOF

  default = {
    # Number of replicas for each terminating gateway defined.
    replicas = 2

    # extraVolumes is a list of extra volumes to mount. These will be exposed
    # to Consul in the path `/consul/userconfig/<name>/`. The value below is
    # an array of objects, examples are shown below.
    #  extraVolumes:
    #    - type: secret
    #      name: my-secret
    #      items:  # optional items array
    #        - key: key
    #          path: path  # secret will now mount to /consul/userconfig/my-secret/path
    extraVolumes = []

    # Resource limits for all terminating gateway pods
    resources = {
      requests = {
        cpu    = "100Mi"
        memory = "100Mi"
      }
      limits = {
        cpu    = "100Mi"
        memory = "100Mi"
      }
    }

    # Resource settings for the `copy-consul-bin` init container.
    initCopyConsulContainer = {
      resources = {
        requests = {
          cpu    = "50m"
          memory = "25Mi"
        }
        limits = {
          cpu    = "50m"
          memory = "25Mi"
        }
      }
    }

    # By default, we set an anti-affinity so that two of the same gateway pods
    # won't be on the same node. NOTE: Gateways require that Consul client agents are
    # also running on the nodes alongside each gateway pod.
    affinity = <<-EOF
      podAntiAffinity:
        requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchLabels:
                app: {{ template "consul.name" . }}
                release: "{{ .Release.Name }}"
                component: terminating-gateway
            topologyKey: kubernetes.io/hostname
      EOF

    # Optional YAML string to specify tolerations.
    tolerations = null

    # Optional YAML string to specify a nodeSelector config.
    nodeSelector = null

    # Optional priorityClassName.
    priorityClassName = ""

    # Annotations to apply to the terminating gateway deployment. Annotations defined
    # here will be applied to all terminating gateway deployments in addition to any
    # annotations defined for a specific gateway in `terminatingGateways.gateways`.
    # Example:
    #   annotations: |
    #     "annotation-key": "annotation-value"
    annotations = null

    # This value defines additional annotations for the terminating gateways' service account. This should be
    # formatted as a multi-line string.
    #
    # ```yaml
    # annotations: |
    #   "sample/annotation1": "foo"
    #   "sample/annotation2": "bar"
    # ```
    serviceAccount = {
      annotations = null
    }

    # [Enterprise Only] `consulNamespace` defines the Consul namespace to register
    # the gateway into.  Requires `global.enableConsulNamespaces` to be true and
    # Consul Enterprise v1.7+ with a valid Consul Enterprise license.
    # Note: The Consul namespace MUST exist before the gateway is deployed.
    consulNamespace = "default"
  }
}

variable "terminating_gateways" {
  description = <<-EOF
      Gateways is a list of gateway objects. The only required field for
      each is `name`, though they can also contain any of the fields in
      `terminating_gateway_defaults`. Values defined here override the defaults except in the
      case of annotations where both will be applied.
    EOF

  default = [
    {
      name = "terminating-gateway"
    }
  ]
}

###########################
# Consul Security
###########################
variable "gossip_encryption_key" {
  description = "32 Bytes Base64 Encoded Consul Gossip Encryption Key. Set to `null` to disable"
  default     = null
}

variable "secret_name" {
  description = "Name of the secret for Consul"
  default     = "consul"
}

variable "secret_annotation" {
  description = "Annotations for the Consul Secret"
  default     = {}
}

variable "tls_enabled" {
  description = "Enable TLS for the cluster"
  default     = false
}

variable "tls_server_additional_dns_sans" {
  description = "List of additional DNS names to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access the Consul server(s) externally, for example, if you're using the UI."
  default     = []
}

variable "tls_server_additional_ip_sans" {
  description = "List of additional IP addresses to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access Consul server(s) externally, for example, if you're using the UI."
  default     = []
}

variable "tls_verify" {
  description = <<EOF
If true, 'verify_outgoing', 'verify_server_hostname', and
'verify_incoming_rpc' will be set to true for Consul servers and clients.
Set this to false to incrementally roll out TLS on an existing Consul cluster.
Note: remember to switch it back to true once the rollout is complete.
Please see this guide for more details:
https://learn.hashicorp.com/consul/security-networking/certificates
EOF

  default = true
}

variable "tls_https_only" {
  description = "If true, Consul will disable the HTTP port on both clients and servers and only accept HTTPS connections."
  default     = true
}

variable "tls_enable_auto_encrypt" {
  description = "Enable auto encrypt. Uses the connect CA to distribute certificates to clients"
  default     = false
}

variable "tls_ca" {
  description = "Self generated CA for Consul Server TLS. Values should be PEM encoded"
  type = object({
    cert = string,
    key  = string,
  })
  default = null
}

variable "tls_server_cert_secret" {
  description = "A Kubernetes secret containing a certificate & key for the server agents to use for TLS communication within the Consul cluster. Additional SANs are required."
  type        = string
  default     = null
}

###########################
# Consul ESM
###########################
variable "enable_esm" {
  description = "Enable Consul ESM deployment"
  type        = bool
  default     = false
}

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

variable "esm_server_address" {
  description = "Override Consul Server address for TLS when using Auto Encrypt"
  type        = string
  default     = null
}

variable "esm_server_port" {
  description = "Override Consul Server port for TLS when using Auto Encrypt"
  type        = number
  default     = null
}


#################################
# Consul Exporter for Prometheus
#################################
variable "enable_exporter" {
  description = "Enable Consul Exporter deployment"
  default     = false
}

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

###########################
# Consul Connect Metrics
###########################
variable "metrics_enabled" {
  description = "Configures the Helm chart’s components to expose Prometheus metrics for the Consul service mesh."
  default     = false
}

variable "enable_agent_metrics" {
  description = "Configures consul agent metrics."
  default     = false
}

variable "agent_metrics_retention_time" {
  description = "Configures the retention time for metrics in Consul clients and servers. This must be greater than 0 for Consul clients and servers to expose any metrics at all."
  default     = "1m"
}

variable "enable_gateway_metrics" {
  description = "If true, mesh, terminating, and ingress gateways will expose their Envoy metrics on port `20200` at the `/metrics` path and all gateway pods will have Prometheus scrape annotations."
  default     = true
}

variable "ui_metrics_enabled" {
  description = "Enable displaying metrics in UI. Defaults to value of var.metrics_enabled"
  default     = "-"
}

variable "ui_metrics_provider" {
  description = "Provider for metrics. See https://www.consul.io/docs/agent/options#ui_config_metrics_provider"
  default     = "prometheus"
}

variable "ui_metrics_base_url" {
  description = "URL of the prometheus server, usually the service URL."
  default     = "http://prometheus-server"
}

variable "connect_inject_metrics_default_enabled" {
  description = <<-EOF
    If true, the connect-injector will automatically
    add prometheus annotations to connect-injected pods. It will also
    add a listener on the Envoy sidecar to expose metrics. The exposed
    metrics will depend on whether metrics merging is enabled:
      - If metrics merging is enabled:
        the Consul sidecar will run a merged metrics server
        combining Envoy sidecar and Connect service metrics,
        i.e. if your service exposes its own Prometheus metrics.
      - If metrics merging is disabled:
        the listener will just expose Envoy sidecar metrics.
    Defaults to var.metrics_enabled
    EOF

  default = "-"
}

variable "connect_inject_default_enable_merging" {
  description = "Configures the Consul sidecar to run a merged metrics server to combine and serve both Envoy and Connect service metrics. This feature is available only in Consul v1.10-alpha or greater."
  default     = false
}

variable "connect_inject_default_merged_metrics_port" {
  description = "Configures the port at which the Consul sidecar will listen on to return combined metrics. This port only needs to be changed if it conflicts with the application's ports."
  default     = 20100
}

variable "connect_inject_default_prometheus_scrape_port" {
  description = <<-EOF
    Configures the port Prometheus will scrape metrics from, by configuring
    the Pod annotation `prometheus.io/port` and the corresponding listener in
    the Envoy sidecar.
    NOTE: This is *not* the port that your application exposes metrics on.
    That can be configured with the
    `consul.hashicorp.com/service-metrics-port` annotation.
    EOF
  default     = 20200
}

variable "connect_inject_default_prometheus_scrape_path" {
  description = <<-EOF
    Configures the path Prometheus will scrape metrics from, by configuring the pod
    annotation `prometheus.io/path` and the corresponding handler in the Envoy
    sidecar.
    NOTE: This is *not* the path that your application exposes metrics on.
    That can be configured with the
    `consul.hashicorp.com/service-metrics-path` annotation.
    EOF
  default     = "/metrics"
}

variable "connect_inject_service_account_annotations" {
  description = "YAML string with annotations for the Connect Inject service account"
  type        = string
  default     = ""
}

##################
# Diff aid
##################
variable "consul_raw_values" {
  description = "Create a `null_resource` with the raw values passed in to render the YAML values file. Useful for observing diffs."
  type        = bool
  default     = true
}
