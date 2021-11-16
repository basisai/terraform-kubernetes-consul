# Terraform Consul on Kubernetes

Deploys a [Consul](https://www.consul.io/) cluster on Kubernetes cluster running on any cloud
provider. This module makes use of the official Hashicorp
[Helm Chart](https://www.consul.io/docs/platform/k8s/helm.html).

For more information regarding Consul's integration with Kubernetes, see the
[documentation](https://www.consul.io/docs/platform/k8s/index.html).

This module is published on
[Terraform Registry](https://registry.terraform.io/modules/basisai/consul/kubernetes/latest).

## Requirements

You will need to have the following resources available:

- A Kubernetes cluster, managed by your cloud provider, or not
- [Helm](https://helm.sh/) with Tiller running on the Cluster or you can opt to run
    [Tiller locally](https://docs.helm.sh/using_helm/#running-tiller-locally)

You will need to have the following configured on your machine:

- Credentials for your Cloud Provider
- Credentials for Kubernetes configured for `kubectl`

## Usage

### Consul Server Persistent Volumes

The Consul servers are deployed with
[persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) in a
[`StatefulSet`](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

If you are running your own cluster in your cloud provider, you will have to define your own set
of storage classes.

If you are using your cloud provider's managed Kubernetes service such as GKE or EKS, they would
have defined their own set of default storage class.

You can use the
[`kubernetes_storage_class`](https://www.terraform.io/docs/providers/kubernetes/r/storage_class.html)
Terraform resource to create a new `StorageClass`.

### Consul Server Resources

You might want to refer to HashiCorp's [guide](https://www.consul.io/docs/guides/performance.html)
and [summary](https://learn.hashicorp.com/consul/advanced/day-1-operations/reference-architecture)
on considering the resources needed for your Consul servers.

### Configuring Consul DNS for `kube-dns`

You can configure Consul to act as the
[DNS resolver](https://www.consul.io/docs/platform/k8s/dns.html) for `.consul` domains. By default,
this module does not attempt to do so manually because there is no good way to append to any
existing `kube-dns` or `CoreDNS` configuration. If you would like to do so, you can set the
`configure_kube_dns` to `true` to **overwrite** any existing `kube-dns` configuration.

#### Error Configuring `kube-dns`

If you get the error:

```text
1 error(s) occurred:

* module.consul.kubernetes_config_map.consul_dns: 1 error(s) occurred:

* kubernetes_config_map.consul_dns: configmaps "kube-dns" already exists

```

You have an existing `kube-dns` configuration. Use
`kubectl describe configMap -n kube-system kube-dns` to see the existing configuration. You can
append to it using the documentation [here](https://www.consul.io/docs/platform/k8s/dns.html).

Alternatively, if the configuration is empty, you can delete it with
`kubectl delete configMap -n kube-system kube-dns`, set variable `configure_kube_dns` to `true`
and let this module manage the configuration.

### Configuring Consul DNS for `CoreDNS`

You can configure Consul to act as the
[DNS resolver](https://www.consul.io/docs/platform/k8s/dns.html) for `.consul` domains. By default,
this module does not attempt to do so manually because there is no good way to append to any
existing `kube-dns` or `CoreDNS` configuration. If you would like to do so, you can set the
`configure_kube_dns` to `true` to **overwrite** any existing `CoreDNS` configuration.

However, you should probably get any existing `CoreDNS` settings and set it to the `core_dns_base` variable.

You can do so by running `kubectl get configmap/coredns -n kube-system -o yaml`.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_esm"></a> [esm](#module\_esm) | ./modules/esm |  |
| <a name="module_prometheus_exporter"></a> [prometheus\_exporter](#module\_prometheus\_exporter) | ./modules/prometheus_exporter |  |

## Resources

| Name | Type |
|------|------|
| [helm_release.consul](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map.consul_core_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_config_map.consul_kube_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map) | resource |
| [kubernetes_secret.secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.consul_values](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [kubernetes_service.consul_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/service) | data source |
| [template_file.consul_core_dns](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_bootstrap_token"></a> [acl\_bootstrap\_token](#input\_acl\_bootstrap\_token) | Use an existing bootstrap token and the consul-k8s will not bootstrap anything | <pre>object({<br>    secret_name = string<br>    secret_key  = string<br>  })</pre> | <pre>{<br>  "secret_key": null,<br>  "secret_name": null<br>}</pre> | no |
| <a name="input_additional_chart_values"></a> [additional\_chart\_values](#input\_additional\_chart\_values) | Additional values for the Consul Helm Chart in YAML | `list(string)` | `[]` | no |
| <a name="input_agent_metrics_retention_time"></a> [agent\_metrics\_retention\_time](#input\_agent\_metrics\_retention\_time) | Configures the retention time for metrics in Consul clients and servers. This must be greater than 0 for Consul clients and servers to expose any metrics at all. | `string` | `"1m"` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | Helm chart name to provision | `string` | `"consul"` | no |
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | Namespace to install the chart into | `string` | `"default"` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | Helm repository for the chart | `string` | `"https://helm.releases.hashicorp.com"` | no |
| <a name="input_chart_timeout"></a> [chart\_timeout](#input\_chart\_timeout) | Timeout to wait for the Chart to be deployed. The chart waits for all Daemonset pods to be healthy before ending. Increase this for larger clusers to avoid timeout | `number` | `1800` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Version of Chart to install. Set to empty to install the latest version | `string` | `"0.36.0"` | no |
| <a name="input_client_affinity"></a> [client\_affinity](#input\_client\_affinity) | affinity Settings for Client pods, formatted as a multi-line YAML string. | `any` | `null` | no |
| <a name="input_client_annotations"></a> [client\_annotations](#input\_client\_annotations) | A YAML string for client pods | `string` | `""` | no |
| <a name="input_client_enabled"></a> [client\_enabled](#input\_client\_enabled) | Enable running Consul client agents on every Kubernetes node | `string` | `"-"` | no |
| <a name="input_client_extra_config"></a> [client\_extra\_config](#input\_client\_extra\_config) | Additional configuration to include for client agents | `map` | `{}` | no |
| <a name="input_client_extra_volumes"></a> [client\_extra\_volumes](#input\_client\_extra\_volumes) | List of map of extra volumes specification. See https://www.consul.io/docs/platform/k8s/helm.html#v-client-extravolumes for the keys | `list` | `[]` | no |
| <a name="input_client_grpc"></a> [client\_grpc](#input\_client\_grpc) | Enable GRPC port for clients. Required for Connect Inject | `bool` | `true` | no |
| <a name="input_client_labels"></a> [client\_labels](#input\_client\_labels) | Additional labels for client pods | `map` | `{}` | no |
| <a name="input_client_priority_class"></a> [client\_priority\_class](#input\_client\_priority\_class) | Priority class for clients | `string` | `""` | no |
| <a name="input_client_resources"></a> [client\_resources](#input\_client\_resources) | Resources for clients | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| <a name="input_client_security_context"></a> [client\_security\_context](#input\_client\_security\_context) | Pod security context for client pods | `map` | <pre>{<br>  "fsGroup": 1000,<br>  "runAsGroup": 1000,<br>  "runAsNonRoot": true,<br>  "runAsUser": 100<br>}</pre> | no |
| <a name="input_client_service_account_annotations"></a> [client\_service\_account\_annotations](#input\_client\_service\_account\_annotations) | YAML string for annotations for client service account | `string` | `""` | no |
| <a name="input_client_tolerations"></a> [client\_tolerations](#input\_client\_tolerations) | A YAML string that can be templated via helm specifying the tolerations for client pods | `string` | `""` | no |
| <a name="input_configure_core_dns"></a> [configure\_core\_dns](#input\_configure\_core\_dns) | Configure core-dns and OVERWRITE it to resolve .consul domains with Consul DNS | `bool` | `false` | no |
| <a name="input_configure_kube_dns"></a> [configure\_kube\_dns](#input\_configure\_kube\_dns) | Configure kube-dns and OVERWRITE it to resolve .consul domains with Consul DNS | `bool` | `false` | no |
| <a name="input_connect_enable"></a> [connect\_enable](#input\_connect\_enable) | Enable consul connect. When enabled, the bootstrap will configure a default CA which can be tweaked using the Consul API later | `bool` | `false` | no |
| <a name="input_connect_inject_acl_binding_rule_selector"></a> [connect\_inject\_acl\_binding\_rule\_selector](#input\_connect\_inject\_acl\_binding\_rule\_selector) | Query that defines which Service Accounts<br>can authenticate to Consul and receive an ACL token during Connect injection.<br>The default setting, i.e. serviceaccount.name!=default, prevents the<br>'default' Service Account from logging in.<br>If set to an empty string all service accounts can log in.<br>This only has effect if ACLs are enabled.<br><br>See https://www.consul.io/docs/acl/acl-auth-methods.html#binding-rules<br>and https://www.consul.io/docs/acl/auth-methods/kubernetes.html#trusted-identity-attributes<br>for more details. | `string` | `"serviceaccount.name!=default"` | no |
| <a name="input_connect_inject_acl_token"></a> [connect\_inject\_acl\_token](#input\_connect\_inject\_acl\_token) | Secret containing ACL token if ACL is enabled and manage\_system\_acls is not enabled | <pre>object({<br>    secret_name = string<br>    secret_key  = string<br>  })</pre> | <pre>{<br>  "secret_key": null,<br>  "secret_name": null<br>}</pre> | no |
| <a name="input_connect_inject_affinity"></a> [connect\_inject\_affinity](#input\_connect\_inject\_affinity) | Template string for Connect Inject Affinity | `string` | `""` | no |
| <a name="input_connect_inject_allowed_namespaces"></a> [connect\_inject\_allowed\_namespaces](#input\_connect\_inject\_allowed\_namespaces) | List of allowed namespaces to inject. | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| <a name="input_connect_inject_by_default"></a> [connect\_inject\_by\_default](#input\_connect\_inject\_by\_default) | If true, the injector will inject the Connect sidecar into all pods by default. Otherwise, pods must specify the injection annotation to opt-in to Connect injection. If this is true, pods can use the same annotation to explicitly opt-out of injection. | `bool` | `false` | no |
| <a name="input_connect_inject_default_enable_merging"></a> [connect\_inject\_default\_enable\_merging](#input\_connect\_inject\_default\_enable\_merging) | Configures the Consul sidecar to run a merged metrics server to combine and serve both Envoy and Connect service metrics. This feature is available only in Consul v1.10-alpha or greater. | `bool` | `false` | no |
| <a name="input_connect_inject_default_merged_metrics_port"></a> [connect\_inject\_default\_merged\_metrics\_port](#input\_connect\_inject\_default\_merged\_metrics\_port) | Configures the port at which the Consul sidecar will listen on to return combined metrics. This port only needs to be changed if it conflicts with the application's ports. | `number` | `20100` | no |
| <a name="input_connect_inject_default_prometheus_scrape_path"></a> [connect\_inject\_default\_prometheus\_scrape\_path](#input\_connect\_inject\_default\_prometheus\_scrape\_path) | Configures the path Prometheus will scrape metrics from, by configuring the pod<br>annotation `prometheus.io/path` and the corresponding handler in the Envoy<br>sidecar.<br>NOTE: This is *not* the path that your application exposes metrics on.<br>That can be configured with the<br>`consul.hashicorp.com/service-metrics-path` annotation. | `string` | `"/metrics"` | no |
| <a name="input_connect_inject_default_prometheus_scrape_port"></a> [connect\_inject\_default\_prometheus\_scrape\_port](#input\_connect\_inject\_default\_prometheus\_scrape\_port) | Configures the port Prometheus will scrape metrics from, by configuring<br>the Pod annotation `prometheus.io/port` and the corresponding listener in<br>the Envoy sidecar.<br>NOTE: This is *not* the port that your application exposes metrics on.<br>That can be configured with the<br>`consul.hashicorp.com/service-metrics-port` annotation. | `number` | `20200` | no |
| <a name="input_connect_inject_denied_namespaces"></a> [connect\_inject\_denied\_namespaces](#input\_connect\_inject\_denied\_namespaces) | List of denied namespaces to inject. | `list` | `[]` | no |
| <a name="input_connect_inject_failure_policy"></a> [connect\_inject\_failure\_policy](#input\_connect\_inject\_failure\_policy) | Sets the failurePolicy for the mutating webhook. By default this will cause pods not part of the consul installation to fail scheduling while the webhook<br>is offline. This prevents a pod from skipping mutation if the webhook were to be momentarily offline.<br>Once the webhook is back online the pod will be scheduled.<br>In some environments such as Kind this may have an undesirable effect as it may prevent volume provisioner pods from running<br>which can lead to hangs. In these environments it is recommend to use "Ignore" instead.<br>This setting can be safely disabled by setting to "Ignore". | `string` | `"Fail"` | no |
| <a name="input_connect_inject_init_resources"></a> [connect\_inject\_init\_resources](#input\_connect\_inject\_init\_resources) | Resource settings for the Connect injected init container. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| <a name="input_connect_inject_log_level"></a> [connect\_inject\_log\_level](#input\_connect\_inject\_log\_level) | Log verbosity level. One of debug, info, warn, or error. | `string` | `""` | no |
| <a name="input_connect_inject_metrics_default_enabled"></a> [connect\_inject\_metrics\_default\_enabled](#input\_connect\_inject\_metrics\_default\_enabled) | If true, the connect-injector will automatically<br>add prometheus annotations to connect-injected pods. It will also<br>add a listener on the Envoy sidecar to expose metrics. The exposed<br>metrics will depend on whether metrics merging is enabled:<br>  - If metrics merging is enabled:<br>    the Consul sidecar will run a merged metrics server<br>    combining Envoy sidecar and Connect service metrics,<br>    i.e. if your service exposes its own Prometheus metrics.<br>  - If metrics merging is disabled:<br>    the listener will just expose Envoy sidecar metrics.<br>Defaults to var.metrics\_enabled | `string` | `"-"` | no |
| <a name="input_connect_inject_namespace_selector"></a> [connect\_inject\_namespace\_selector](#input\_connect\_inject\_namespace\_selector) | A YAML string selector for restricting injection to only matching namespaces. By default all namespaces except the system namespace will have injection enabled. | `string` | `"matchExpressions:\n  - key: \"kubernetes.io/metadata.name\"\n    operator: \"NotIn\"\n    values: [\"kube-system\",\"local-path-storage\"]\n"` | no |
| <a name="input_connect_inject_override_auth_method_name"></a> [connect\_inject\_override\_auth\_method\_name](#input\_connect\_inject\_override\_auth\_method\_name) | If you are not using global.acls.manageSystemACLs and instead manually setting up an auth method for Connect inject, set this to the name of your auth method. | `string` | `""` | no |
| <a name="input_connect_inject_priority_class"></a> [connect\_inject\_priority\_class](#input\_connect\_inject\_priority\_class) | Pod Priority Class for Connect Inject | `string` | `""` | no |
| <a name="input_connect_inject_replicas"></a> [connect\_inject\_replicas](#input\_connect\_inject\_replicas) | Number of replicas for Connect Inject deployment | `number` | `2` | no |
| <a name="input_connect_inject_resources"></a> [connect\_inject\_resources](#input\_connect\_inject\_resources) | Resources for connect inject pod | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| <a name="input_connect_inject_service_account_annotations"></a> [connect\_inject\_service\_account\_annotations](#input\_connect\_inject\_service\_account\_annotations) | YAML string with annotations for the Connect Inject service account | `string` | `""` | no |
| <a name="input_connect_inject_sidecar_proxy_resources"></a> [connect\_inject\_sidecar\_proxy\_resources](#input\_connect\_inject\_sidecar\_proxy\_resources) | Set default resources for sidecar proxy. If null, that resource won't be set. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| <a name="input_connect_inject_tolerations"></a> [connect\_inject\_tolerations](#input\_connect\_inject\_tolerations) | Template string for Connect Inject Tolerations | `string` | `""` | no |
| <a name="input_consul_domain"></a> [consul\_domain](#input\_consul\_domain) | Top level Consul domain for DNS queries | `string` | `"consul"` | no |
| <a name="input_consul_image_name"></a> [consul\_image\_name](#input\_consul\_image\_name) | Docker Image of Consul to run | `string` | `"consul"` | no |
| <a name="input_consul_image_tag"></a> [consul\_image\_tag](#input\_consul\_image\_tag) | Docker image tag of Consul to run | `string` | `"1.10.4"` | no |
| <a name="input_consul_k8s_image"></a> [consul\_k8s\_image](#input\_consul\_k8s\_image) | Docker image of the consul-k8s binary to run | `string` | `"hashicorp/consul-k8s-control-plane"` | no |
| <a name="input_consul_k8s_tag"></a> [consul\_k8s\_tag](#input\_consul\_k8s\_tag) | Image tag of the consul-k8s binary to run | `string` | `"0.36.0"` | no |
| <a name="input_consul_raw_values"></a> [consul\_raw\_values](#input\_consul\_raw\_values) | Create a `null_resource` with the raw values passed in to render the YAML values file. Useful for observing diffs. | `bool` | `true` | no |
| <a name="input_consul_recursors"></a> [consul\_recursors](#input\_consul\_recursors) | A list of addresses of upstream DNS servers that are used to recursively resolve DNS queries. | `list(string)` | `[]` | no |
| <a name="input_consul_sidecar_container_resources"></a> [consul\_sidecar\_container\_resources](#input\_consul\_sidecar\_container\_resources) | Resource settings for consul -sidecar containers.<br>The consul  sidecar ensures the Consul services are always registered with<br>their local consul clients and is used by the ingress/terminating/mesh gateways<br>as well as with every connect-injected service. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "20m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "20m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| <a name="input_consul_template_image"></a> [consul\_template\_image](#input\_consul\_template\_image) | Image for Consul Template | `string` | `"hashicorp/consul-template:0.26.0"` | no |
| <a name="input_controller_acl_token"></a> [controller\_acl\_token](#input\_controller\_acl\_token) | Secret containing ACL token if ACL is enabled and manage\_system\_acls is not enabled | <pre>object({<br>    secret_name = string<br>    secret_key  = string<br>  })</pre> | <pre>{<br>  "secret_key": null,<br>  "secret_name": null<br>}</pre> | no |
| <a name="input_controller_enable"></a> [controller\_enable](#input\_controller\_enable) | Enable Consul Configuration Entries CRD Controller | `bool` | `false` | no |
| <a name="input_controller_log_level"></a> [controller\_log\_level](#input\_controller\_log\_level) | CRD Controller Log level. | `string` | `""` | no |
| <a name="input_controller_node_affinity"></a> [controller\_node\_affinity](#input\_controller\_node\_affinity) | YAML string for Controller affinity | `any` | `null` | no |
| <a name="input_controller_node_selector"></a> [controller\_node\_selector](#input\_controller\_node\_selector) | YAML string for Controller Node Selector | `any` | `null` | no |
| <a name="input_controller_node_tolerations"></a> [controller\_node\_tolerations](#input\_controller\_node\_tolerations) | YAML string for Controller tolerations | `any` | `null` | no |
| <a name="input_controller_priority_class"></a> [controller\_priority\_class](#input\_controller\_priority\_class) | Priority class for Controller pods | `string` | `""` | no |
| <a name="input_controller_replicas"></a> [controller\_replicas](#input\_controller\_replicas) | Number of replicas for the CRD controller | `number` | `1` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | CRD Controller resources | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| <a name="input_controller_service_account_annotations"></a> [controller\_service\_account\_annotations](#input\_controller\_service\_account\_annotations) | YAML string with annotations for CRD Controller service account | `string` | `""` | no |
| <a name="input_core_dns_labels"></a> [core\_dns\_labels](#input\_core\_dns\_labels) | Labels for CoreDNS ConfigMap | `map` | <pre>{<br>  "addonmanager.kubernetes.io/mode": "EnsureExists",<br>  "eks.amazonaws.com/component": "coredns",<br>  "k8s-app": "kube-dns"<br>}</pre> | no |
| <a name="input_core_dns_template"></a> [core\_dns\_template](#input\_core\_dns\_template) | Template for CoreDNS `CoreFile` configuration. Use Terraform string interpolation format with the variable `consul_dns_address` for Consul DNS endpoint. See Default for an example | `string` | `".:53 {\n  errors\n  health\n  kubernetes cluster.local in-addr.arpa ip6.arpa {\n    pods insecure\n    fallthrough in-addr.arpa ip6.arpa\n  }\n  prometheus :9153\n  forward . /etc/resolv.conf\n  cache 30\n  loop\n  reload\n  loadbalance\n}\n\nconsul {\n  errors\n  cache 30\n  forward . ${consul_dns_address}\n}\n"` | no |
| <a name="input_create_replication_token"></a> [create\_replication\_token](#input\_create\_replication\_token) | If true, an ACL token will be created that can be used in secondary datacenters for replication. This should only be set to true in the primary datacenter since the replication token must be created from that datacenter. In secondary datacenters, the secret needs to be imported from the primary datacenter | `bool` | `false` | no |
| <a name="input_enable_agent_metrics"></a> [enable\_agent\_metrics](#input\_enable\_agent\_metrics) | Configures consul agent metrics. | `bool` | `false` | no |
| <a name="input_enable_connect_inject"></a> [enable\_connect\_inject](#input\_enable\_connect\_inject) | Enable Connect Injector process | `bool` | `false` | no |
| <a name="input_enable_esm"></a> [enable\_esm](#input\_enable\_esm) | Enable Consul ESM deployment | `bool` | `false` | no |
| <a name="input_enable_exporter"></a> [enable\_exporter](#input\_enable\_exporter) | Enable Consul Exporter deployment | `bool` | `false` | no |
| <a name="input_enable_gateway_metrics"></a> [enable\_gateway\_metrics](#input\_enable\_gateway\_metrics) | If true, mesh, terminating, and ingress gateways will expose their Envoy metrics on port `20200` at the `/metrics` path and all gateway pods will have Prometheus scrape annotations. | `bool` | `true` | no |
| <a name="input_enable_sync_catalog"></a> [enable\_sync\_catalog](#input\_enable\_sync\_catalog) | Enable Service catalog sync: https://www.consul.io/docs/platform/k8s/service-sync.html | `bool` | `true` | no |
| <a name="input_enable_ui"></a> [enable\_ui](#input\_enable\_ui) | Enable Consul UI | `bool` | `false` | no |
| <a name="input_envoy_extra_args"></a> [envoy\_extra\_args](#input\_envoy\_extra\_args) | Pass arguments to the injected envoy sidecar. Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli | `any` | `null` | no |
| <a name="input_esm_affinity"></a> [esm\_affinity](#input\_esm\_affinity) | Affinity for ESM | `any` | `{}` | no |
| <a name="input_esm_chart_name"></a> [esm\_chart\_name](#input\_esm\_chart\_name) | Name of the ESM Chart name | `string` | `"consul-esm"` | no |
| <a name="input_esm_chart_repository"></a> [esm\_chart\_repository](#input\_esm\_chart\_repository) | ESM Chart repository | `string` | `"https://basisai.github.io/charts/"` | no |
| <a name="input_esm_chart_version"></a> [esm\_chart\_version](#input\_esm\_chart\_version) | ESM Chart version | `string` | `"0.3.1"` | no |
| <a name="input_esm_container_security_context"></a> [esm\_container\_security\_context](#input\_esm\_container\_security\_context) | securityContext for ESM containers | `any` | `{}` | no |
| <a name="input_esm_env"></a> [esm\_env](#input\_esm\_env) | Environment variables for Consul ESM | `any` | `[]` | no |
| <a name="input_esm_external_node_meta"></a> [esm\_external\_node\_meta](#input\_esm\_external\_node\_meta) | The node metadata values used for the ESM to qualify a node in the catalog as an "external node". | `map(string)` | <pre>{<br>  "external-node": "true"<br>}</pre> | no |
| <a name="input_esm_http_addr"></a> [esm\_http\_addr](#input\_esm\_http\_addr) | HTTP address of the local Consul agent | `string` | `""` | no |
| <a name="input_esm_image"></a> [esm\_image](#input\_esm\_image) | Docker image for ESM | `string` | `"hashicorp/consul-esm"` | no |
| <a name="input_esm_init_container_set_sysctl"></a> [esm\_init\_container\_set\_sysctl](#input\_esm\_init\_container\_set\_sysctl) | Enable setting sysctl settings via a privileged container to allow pings | `bool` | `false` | no |
| <a name="input_esm_kv_path"></a> [esm\_kv\_path](#input\_esm\_kv\_path) | The directory in the Consul KV store to use for storing ESM runtime data. | `string` | `"consul-esm/"` | no |
| <a name="input_esm_log_level"></a> [esm\_log\_level](#input\_esm\_log\_level) | Log level for ESM | `string` | `"INFO"` | no |
| <a name="input_esm_node_agent_port"></a> [esm\_node\_agent\_port](#input\_esm\_node\_agent\_port) | Override port for Consul agent Daemonset | `number` | `null` | no |
| <a name="input_esm_node_probe_interval"></a> [esm\_node\_probe\_interval](#input\_esm\_node\_probe\_interval) | The interval to ping and update coordinates for external nodes that have 'external-probe' set to true. By default, ESM will attempt to ping and  update the coordinates for all nodes it is watching every 10 seconds. | `string` | `"10s"` | no |
| <a name="input_esm_node_reconnect_timeout"></a> [esm\_node\_reconnect\_timeout](#input\_esm\_node\_reconnect\_timeout) | The length of time to wait before reaping an external node due to failed pings. | `string` | `"72h"` | no |
| <a name="input_esm_ping_type"></a> [esm\_ping\_type](#input\_esm\_ping\_type) | The method to use for pinging external nodes. | `string` | `"udp"` | no |
| <a name="input_esm_pod_annotations"></a> [esm\_pod\_annotations](#input\_esm\_pod\_annotations) | Annotations for Consul ESM Pods | `map(string)` | `{}` | no |
| <a name="input_esm_pod_security_context"></a> [esm\_pod\_security\_context](#input\_esm\_pod\_security\_context) | securityContext for ESM pods | `any` | `{}` | no |
| <a name="input_esm_release_name"></a> [esm\_release\_name](#input\_esm\_release\_name) | Name of the ESM Chart Release | `string` | `"consul-esm"` | no |
| <a name="input_esm_replica"></a> [esm\_replica](#input\_esm\_replica) | Number of ESM replica | `number` | `3` | no |
| <a name="input_esm_resources"></a> [esm\_resources](#input\_esm\_resources) | Resources for ESM | `any` | <pre>{<br>  "limits": {<br>    "memory": "256Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m"<br>  }<br>}</pre> | no |
| <a name="input_esm_server_address"></a> [esm\_server\_address](#input\_esm\_server\_address) | Override Consul Server address for TLS when using Auto Encrypt | `string` | `null` | no |
| <a name="input_esm_server_port"></a> [esm\_server\_port](#input\_esm\_server\_port) | Override Consul Server port for TLS when using Auto Encrypt | `number` | `null` | no |
| <a name="input_esm_service_name"></a> [esm\_service\_name](#input\_esm\_service\_name) | ESM service name in Consul | `string` | `"consul-esm"` | no |
| <a name="input_esm_service_tag"></a> [esm\_service\_tag](#input\_esm\_service\_tag) | Service tag for ESM | `string` | `""` | no |
| <a name="input_esm_tag"></a> [esm\_tag](#input\_esm\_tag) | Docker Image tag for ESM | `string` | `"0.6.0"` | no |
| <a name="input_esm_tolerations"></a> [esm\_tolerations](#input\_esm\_tolerations) | Toleration for ESM | `any` | `[]` | no |
| <a name="input_esm_use_node_agent"></a> [esm\_use\_node\_agent](#input\_esm\_use\_node\_agent) | Use Consul agent Daemonset | `bool` | `true` | no |
| <a name="input_exporter_affinity"></a> [exporter\_affinity](#input\_exporter\_affinity) | Affinity for Consul Exporter | `map` | `{}` | no |
| <a name="input_exporter_chart_name"></a> [exporter\_chart\_name](#input\_exporter\_chart\_name) | Name of the Consul Exporter Chart name | `string` | `"prometheus-consul-exporter"` | no |
| <a name="input_exporter_chart_repository"></a> [exporter\_chart\_repository](#input\_exporter\_chart\_repository) | Consul Exporter Chart repository | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| <a name="input_exporter_chart_version"></a> [exporter\_chart\_version](#input\_exporter\_chart\_version) | Consul Exporter Chart version | `string` | `"0.4.0"` | no |
| <a name="input_exporter_env"></a> [exporter\_env](#input\_exporter\_env) | Additional Environment Variables for Exporter | `list` | `[]` | no |
| <a name="input_exporter_extra_containers"></a> [exporter\_extra\_containers](#input\_exporter\_extra\_containers) | Extra extra Containers | `list` | `[]` | no |
| <a name="input_exporter_extra_volume_mounts"></a> [exporter\_extra\_volume\_mounts](#input\_exporter\_extra\_volume\_mounts) | Extra volume mounts for Exporter | `list` | `[]` | no |
| <a name="input_exporter_extra_volumes"></a> [exporter\_extra\_volumes](#input\_exporter\_extra\_volumes) | Extra volumes for Exporter | `list` | `[]` | no |
| <a name="input_exporter_image"></a> [exporter\_image](#input\_exporter\_image) | Docker image for Consul Exporter | `string` | `"prom/consul-exporter"` | no |
| <a name="input_exporter_init_containers"></a> [exporter\_init\_containers](#input\_exporter\_init\_containers) | Extra Init Containers | `list` | `[]` | no |
| <a name="input_exporter_options"></a> [exporter\_options](#input\_exporter\_options) | Arguments for Exporter. See https://github.com/prometheus/consul_exporter#flags | `map` | `{}` | no |
| <a name="input_exporter_pod_annotations"></a> [exporter\_pod\_annotations](#input\_exporter\_pod\_annotations) | Annotations for Exporter Pods | `map(string)` | `{}` | no |
| <a name="input_exporter_psp"></a> [exporter\_psp](#input\_exporter\_psp) | Create PSP resources for Exporter | `bool` | `true` | no |
| <a name="input_exporter_rbac_enabled"></a> [exporter\_rbac\_enabled](#input\_exporter\_rbac\_enabled) | Create RBAC resources for Exporter | `bool` | `true` | no |
| <a name="input_exporter_release_name"></a> [exporter\_release\_name](#input\_exporter\_release\_name) | Name of the Consul Exporter Chart Release | `string` | `"consul-exporter"` | no |
| <a name="input_exporter_replica"></a> [exporter\_replica](#input\_exporter\_replica) | Number of Consul Exporter replicas | `number` | `1` | no |
| <a name="input_exporter_resources"></a> [exporter\_resources](#input\_exporter\_resources) | Resources for Consul Exporter | `map` | <pre>{<br>  "limits": {<br>    "memory": "256Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m"<br>  }<br>}</pre> | no |
| <a name="input_exporter_service_annotations"></a> [exporter\_service\_annotations](#input\_exporter\_service\_annotations) | Consul Exporter service's annotations | `map` | `{}` | no |
| <a name="input_exporter_service_monitor"></a> [exporter\_service\_monitor](#input\_exporter\_service\_monitor) | Create a ServiceMonitor to configure scraping | `bool` | `false` | no |
| <a name="input_exporter_tag"></a> [exporter\_tag](#input\_exporter\_tag) | Docker Image tag for Consul Exporter | `string` | `"v0.7.1"` | no |
| <a name="input_exporter_tolerations"></a> [exporter\_tolerations](#input\_exporter\_tolerations) | Tolerations for Consul Exporter | `list` | `[]` | no |
| <a name="input_fullname_override"></a> [fullname\_override](#input\_fullname\_override) | Fullname Override of Helm resources | `string` | `""` | no |
| <a name="input_gossip_encryption_key"></a> [gossip\_encryption\_key](#input\_gossip\_encryption\_key) | 32 Bytes Base64 Encoded Consul Gossip Encryption Key. Set to `null` to disable | `any` | `null` | no |
| <a name="input_image_envoy"></a> [image\_envoy](#input\_image\_envoy) | Image and tag for Envoy Docker image to use for sidecar proxies, mesh, terminating and ingress gateways | `string` | `"envoyproxy/envoy-alpine:v1.18.4"` | no |
| <a name="input_log_json_enable"></a> [log\_json\_enable](#input\_log\_json\_enable) | Enable all component logs to be output in JSON format | `bool` | `false` | no |
| <a name="input_manage_system_acls"></a> [manage\_system\_acls](#input\_manage\_system\_acls) | Manager ACL Tokens for Consul and consul-k8s components | `bool` | `false` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Max History for Helm | `number` | `20` | no |
| <a name="input_metrics_enabled"></a> [metrics\_enabled](#input\_metrics\_enabled) | Configures the Helm chart’s components to expose Prometheus metrics for the Consul service mesh. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Sets the prefix used for all resources in the helm chart. If not set, the prefix will be "<helm release name>-consul". | `any` | `null` | no |
| <a name="input_pod_security_policy_enable"></a> [pod\_security\_policy\_enable](#input\_pod\_security\_policy\_enable) | Create PodSecurityPolicy Resources | `bool` | `true` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | Helm release name for Consul | `string` | `"consul"` | no |
| <a name="input_replication_token"></a> [replication\_token](#input\_replication\_token) | A secret containing the replication ACL token. | <pre>object({<br>    secret_name = string<br>    secret_key  = string<br>  })</pre> | <pre>{<br>  "secret_key": null,<br>  "secret_name": null<br>}</pre> | no |
| <a name="input_secret_annotation"></a> [secret\_annotation](#input\_secret\_annotation) | Annotations for the Consul Secret | `map` | `{}` | no |
| <a name="input_secret_name"></a> [secret\_name](#input\_secret\_name) | Name of the secret for Consul | `string` | `"consul"` | no |
| <a name="input_server_affinity"></a> [server\_affinity](#input\_server\_affinity) | A YAML string that can be templated via helm specifying the affinity for server pods | `string` | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          app: {{ template \"consul.name\" . }}\n          release: \"{{ .Release.Name }}\"\n          component: server\n      topologyKey: kubernetes.io/hostname\n"` | no |
| <a name="input_server_annotations"></a> [server\_annotations](#input\_server\_annotations) | A YAML string for server pods | `string` | `""` | no |
| <a name="input_server_datacenter"></a> [server\_datacenter](#input\_server\_datacenter) | Datacenter to configure Consul as. | `any` | n/a | yes |
| <a name="input_server_extra_config"></a> [server\_extra\_config](#input\_server\_extra\_config) | Additional configuration to include for servers in JSON/HCL | `map` | `{}` | no |
| <a name="input_server_extra_volumes"></a> [server\_extra\_volumes](#input\_server\_extra\_volumes) | List of map of extra volumes specification for server pods. See https://www.consul.io/docs/platform/k8s/helm.html#v-server-extravolumes for the keys | `list` | `[]` | no |
| <a name="input_server_priority_class"></a> [server\_priority\_class](#input\_server\_priority\_class) | Priority class for servers | `string` | `""` | no |
| <a name="input_server_replicas"></a> [server\_replicas](#input\_server\_replicas) | Number of server replicas to run | `number` | `5` | no |
| <a name="input_server_resources"></a> [server\_resources](#input\_server\_resources) | Resources for server | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| <a name="input_server_security_context"></a> [server\_security\_context](#input\_server\_security\_context) | Security context for server pods | `map` | <pre>{<br>  "fsGroup": 1000,<br>  "runAsGroup": 1000,<br>  "runAsNonRoot": true,<br>  "runAsUser": 100<br>}</pre> | no |
| <a name="input_server_service_account_annotations"></a> [server\_service\_account\_annotations](#input\_server\_service\_account\_annotations) | YAML string for annotations for server service account | `string` | `""` | no |
| <a name="input_server_storage"></a> [server\_storage](#input\_server\_storage) | This defines the disk size for configuring the servers' StatefulSet storage. For dynamically provisioned storage classes, this is the desired size. For manually defined persistent volumes, this should be set to the disk size of the attached volume. | `string` | `"10Gi"` | no |
| <a name="input_server_storage_class"></a> [server\_storage\_class](#input\_server\_storage\_class) | The StorageClass to use for the servers' StatefulSet storage. It must be able to be dynamically provisioned if you want the storage to be automatically created. For example, to use Local storage classes, the PersistentVolumeClaims would need to be manually created. An empty value will use the Kubernetes cluster's default StorageClass. | `string` | `""` | no |
| <a name="input_server_tolerations"></a> [server\_tolerations](#input\_server\_tolerations) | A YAML string that can be templated via helm specifying the tolerations for server pods | `string` | `""` | no |
| <a name="input_server_topology_spread_constraints"></a> [server\_topology\_spread\_constraints](#input\_server\_topology\_spread\_constraints) | YAML string for topology spread constraints for server pods | `string` | `""` | no |
| <a name="input_server_update_partition"></a> [server\_update\_partition](#input\_server\_update\_partition) | This value is used to carefully control a rolling update of Consul server agents. This value specifies the partition (https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#partitions) for performing a rolling update. Please read the linked Kubernetes documentation and https://www.consul.io/docs/k8s/upgrade#upgrading-consul-servers for more information. | `number` | `0` | no |
| <a name="input_sync_acl_token"></a> [sync\_acl\_token](#input\_sync\_acl\_token) | Secret containing ACL token if ACL is enabled and manage\_system\_acls is not enabled | <pre>object({<br>    secret_name = string<br>    secret_key  = string<br>  })</pre> | <pre>{<br>  "secret_key": null,<br>  "secret_name": null<br>}</pre> | no |
| <a name="input_sync_add_k8s_namespace_suffix"></a> [sync\_add\_k8s\_namespace\_suffix](#input\_sync\_add\_k8s\_namespace\_suffix) | Appends Kubernetes namespace suffix to each service name synced to Consul, separated by a dash. | `bool` | `true` | no |
| <a name="input_sync_affinity"></a> [sync\_affinity](#input\_sync\_affinity) | YAML template string for Sync Catalog affinity | `string` | `""` | no |
| <a name="input_sync_by_default"></a> [sync\_by\_default](#input\_sync\_by\_default) | If true, all valid services in K8S are synced by default. If false, the service must be annotated properly to sync. In either case an annotation can override the default. | `bool` | `true` | no |
| <a name="input_sync_cluster_ip_services"></a> [sync\_cluster\_ip\_services](#input\_sync\_cluster\_ip\_services) | If true, will sync Kubernetes ClusterIP services to Consul. This can be disabled to have the sync ignore ClusterIP-type services. | `bool` | `true` | no |
| <a name="input_sync_k8s_prefix"></a> [sync\_k8s\_prefix](#input\_sync\_k8s\_prefix) | A prefix to prepend to all services registered in Kubernetes from Consul. This defaults to '' where no prefix is prepended; Consul services are synced with the same name to Kubernetes. (Consul -> Kubernetes sync only) | `string` | `""` | no |
| <a name="input_sync_k8s_tag"></a> [sync\_k8s\_tag](#input\_sync\_k8s\_tag) | An optional tag that is applied to all of the Kubernetes services that are synced into Consul. If nothing is set, this defaults to 'k8s'. (Kubernetes -> Consul sync only) | `string` | `"k8s"` | no |
| <a name="input_sync_node_port_type"></a> [sync\_node\_port\_type](#input\_sync\_node\_port\_type) | Configures the type of syncing that happens for NodePort services. The only valid options are: ExternalOnly, InternalOnly, and ExternalFirst. ExternalOnly will only use a node's ExternalIP address for the sync, otherwise the service will not be synced. InternalOnly uses the node's InternalIP address. ExternalFirst will preferentially use the node's ExternalIP address, but if it doesn't exist, it will use the node's InternalIP address instead. | `string` | `""` | no |
| <a name="input_sync_priority_class"></a> [sync\_priority\_class](#input\_sync\_priority\_class) | Priority Class Name for Consul Sync Catalog | `string` | `""` | no |
| <a name="input_sync_resources"></a> [sync\_resources](#input\_sync\_resources) | Sync Catalog resources | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| <a name="input_sync_service_account_annotations"></a> [sync\_service\_account\_annotations](#input\_sync\_service\_account\_annotations) | YAML string for annotations for sync catalog service account | `string` | `""` | no |
| <a name="input_sync_to_consul"></a> [sync\_to\_consul](#input\_sync\_to\_consul) | If true, will sync Kubernetes services to Consul. This can be disabled to have a one-way sync. | `bool` | `true` | no |
| <a name="input_sync_to_k8s"></a> [sync\_to\_k8s](#input\_sync\_to\_k8s) | If true, will sync Consul services to Kubernetes. This can be disabled to have a one-way sync. | `bool` | `true` | no |
| <a name="input_sync_tolerations"></a> [sync\_tolerations](#input\_sync\_tolerations) | Template string for Sync Catalog Tolerations | `string` | `""` | no |
| <a name="input_terminating_gateway_defaults"></a> [terminating\_gateway\_defaults](#input\_terminating\_gateway\_defaults) | Terminating Gateway defaults.<br>You can override any of these fields under `terminating_gateways`.<br>Annotations are concatenated<br><br>Note: You do not have to specify all of the fields to override them. If you omit them, they will<br>fall back to the defaults for the Helm Chart. | `map` | <pre>{<br>  "affinity": "podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          app: {{ template \"consul.name\" . }}\n          release: \"{{ .Release.Name }}\"\n          component: terminating-gateway\n      topologyKey: kubernetes.io/hostname\n",<br>  "annotations": null,<br>  "consulNamespace": "default",<br>  "extraVolumes": [],<br>  "initCopyConsulContainer": {<br>    "resources": {<br>      "limits": {<br>        "cpu": "50m",<br>        "memory": "25Mi"<br>      },<br>      "requests": {<br>        "cpu": "50m",<br>        "memory": "25Mi"<br>      }<br>    }<br>  },<br>  "nodeSelector": null,<br>  "priorityClassName": "",<br>  "replicas": 2,<br>  "resources": {<br>    "limits": {<br>      "cpu": "100Mi",<br>      "memory": "100Mi"<br>    },<br>    "requests": {<br>      "cpu": "100Mi",<br>      "memory": "100Mi"<br>    }<br>  },<br>  "serviceAccount": {<br>    "annotations": null<br>  },<br>  "tolerations": null<br>}</pre> | no |
| <a name="input_terminating_gateway_enable"></a> [terminating\_gateway\_enable](#input\_terminating\_gateway\_enable) | Deploy Terminating Gateways | `bool` | `false` | no |
| <a name="input_terminating_gateways"></a> [terminating\_gateways](#input\_terminating\_gateways) | Gateways is a list of gateway objects. The only required field for<br>each is `name`, though they can also contain any of the fields in<br>`terminating_gateway_defaults`. Values defined here override the defaults except in the<br>case of annotations where both will be applied. | `list` | <pre>[<br>  {<br>    "name": "terminating-gateway"<br>  }<br>]</pre> | no |
| <a name="input_tls_ca"></a> [tls\_ca](#input\_tls\_ca) | Self generated CA for Consul Server TLS. Values should be PEM encoded | <pre>object({<br>    cert = string,<br>    key  = string,<br>  })</pre> | `null` | no |
| <a name="input_tls_enable_auto_encrypt"></a> [tls\_enable\_auto\_encrypt](#input\_tls\_enable\_auto\_encrypt) | Enable auto encrypt. Uses the connect CA to distribute certificates to clients | `bool` | `false` | no |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | Enable TLS for the cluster | `bool` | `false` | no |
| <a name="input_tls_https_only"></a> [tls\_https\_only](#input\_tls\_https\_only) | If true, Consul will disable the HTTP port on both clients and servers and only accept HTTPS connections. | `bool` | `true` | no |
| <a name="input_tls_server_additional_dns_sans"></a> [tls\_server\_additional\_dns\_sans](#input\_tls\_server\_additional\_dns\_sans) | List of additional DNS names to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access the Consul server(s) externally, for example, if you're using the UI. | `list` | `[]` | no |
| <a name="input_tls_server_additional_ip_sans"></a> [tls\_server\_additional\_ip\_sans](#input\_tls\_server\_additional\_ip\_sans) | List of additional IP addresses to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access Consul server(s) externally, for example, if you're using the UI. | `list` | `[]` | no |
| <a name="input_tls_server_cert_secret"></a> [tls\_server\_cert\_secret](#input\_tls\_server\_cert\_secret) | A Kubernetes secret containing a certificate & key for the server agents to use for TLS communication within the Consul cluster. Additional SANs are required. | `string` | `null` | no |
| <a name="input_tls_verify"></a> [tls\_verify](#input\_tls\_verify) | If true, 'verify\_outgoing', 'verify\_server\_hostname', and<br>'verify\_incoming\_rpc' will be set to true for Consul servers and clients.<br>Set this to false to incrementally roll out TLS on an existing Consul cluster.<br>Note: remember to switch it back to true once the rollout is complete.<br>Please see this guide for more details:<br>https://learn.hashicorp.com/consul/security-networking/certificates | `bool` | `true` | no |
| <a name="input_transparent_proxy_default_enabled"></a> [transparent\_proxy\_default\_enabled](#input\_transparent\_proxy\_default\_enabled) | Enable transparent proxy by default on all connect injected pods | `bool` | `true` | no |
| <a name="input_transparent_proxy_default_overwrite_probes"></a> [transparent\_proxy\_default\_overwrite\_probes](#input\_transparent\_proxy\_default\_overwrite\_probes) | Overwrite HTTP probes by default when transparent proxy is in use | `bool` | `true` | no |
| <a name="input_ui_additional_spec"></a> [ui\_additional\_spec](#input\_ui\_additional\_spec) | Additional Spec for the UI service | `string` | `""` | no |
| <a name="input_ui_annotations"></a> [ui\_annotations](#input\_ui\_annotations) | UI service annotations | `string` | `""` | no |
| <a name="input_ui_metrics_base_url"></a> [ui\_metrics\_base\_url](#input\_ui\_metrics\_base\_url) | URL of the prometheus server, usually the service URL. | `string` | `"http://prometheus-server"` | no |
| <a name="input_ui_metrics_enabled"></a> [ui\_metrics\_enabled](#input\_ui\_metrics\_enabled) | Enable displaying metrics in UI. Defaults to value of var.metrics\_enabled | `string` | `"-"` | no |
| <a name="input_ui_metrics_provider"></a> [ui\_metrics\_provider](#input\_ui\_metrics\_provider) | Provider for metrics. See https://www.consul.io/docs/agent/options#ui_config_metrics_provider | `string` | `"prometheus"` | no |
| <a name="input_ui_service_type"></a> [ui\_service\_type](#input\_ui\_service\_type) | Type of service for Consul UI | `string` | `"ClusterIP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kube_dns_service_cluster_ip"></a> [kube\_dns\_service\_cluster\_ip](#output\_kube\_dns\_service\_cluster\_ip) | Cluster IP of the Consul DNS service |
| <a name="output_release"></a> [release](#output\_release) | Helm Release Object |
