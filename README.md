# Terraform Consul on Kubenretes

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
| terraform | >= 0.12 |
| helm | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 1.0 |
| kubernetes | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| chart\_name | Helm chart name to provision | `string` | `"consul"` | no |
| chart\_namespace | Namespace to install the chart into | `string` | `"default"` | no |
| chart\_repository | Helm repository for the chart | `string` | `"https://helm.releases.hashicorp.com"` | no |
| chart\_timeout | Timeout to wait for the Chart to be deployed. The chart waits for all Daemonset pods to be healthy before ending. Increase this for larger clusers to avoid timeout | `number` | `1800` | no |
| chart\_version | Version of Chart to install. Set to empty to install the latest version | `string` | `"0.27.0"` | no |
| client\_annotations | A YAML string for client pods | `string` | `""` | no |
| client\_enabled | Enable running Consul client agents on every Kubernetes node | `string` | `"-"` | no |
| client\_extra\_config | Additional configuration to include for client agents | `map` | `{}` | no |
| client\_extra\_volumes | List of map of extra volumes specification. See https://www.consul.io/docs/platform/k8s/helm.html#v-client-extravolumes for the keys | `list` | `[]` | no |
| client\_grpc | Enable GRPC port for clients. Required for Connect Inject | `bool` | `true` | no |
| client\_priority\_class | Priority class for clients | `string` | `""` | no |
| client\_resources | Resources for clients | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| client\_tolerations | A YAML string that can be templated via helm specifying the tolerations for client pods | `string` | `""` | no |
| configure\_core\_dns | Configure core-dns and OVERWRITE it to resolve .consul domains with Consul DNS | `bool` | `false` | no |
| configure\_kube\_dns | Configure kube-dns and OVERWRITE it to resolve .consul domains with Consul DNS | `bool` | `false` | no |
| connect\_enable | Enable consul connect. When enabled, the bootstrap will configure a default CA which can be tweaked using the Consul API later | `bool` | `false` | no |
| connect\_inject\_affinity | Template string for Connect Inject Affinity | `string` | `""` | no |
| connect\_inject\_allowed\_namespaces | List of allowed namespaces to inject. | `list` | <pre>[<br>  "*"<br>]</pre> | no |
| connect\_inject\_by\_default | If true, the injector will inject the Connect sidecar into all pods by default. Otherwise, pods must specify the injection annotation to opt-in to Connect injection. If this is true, pods can use the same annotation to explicitly opt-out of injection. | `bool` | `false` | no |
| connect\_inject\_default\_protocol | specify a convenience default protocol if most of your services are of the same protocol type. The individual annotation on any given pod will override this value.  Valid values are 'http', 'http2', 'grpc' and 'tcp'. | `any` | `null` | no |
| connect\_inject\_denied\_namespaces | List of denied namespaces to inject. | `list` | `[]` | no |
| connect\_inject\_init\_resources | Resource settings for the Connect injected init container. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| connect\_inject\_log\_level | Log verbosity level. One of debug, info, warn, or error. | `string` | `"info"` | no |
| connect\_inject\_namespace\_selector | A YAML string selector for restricting injection to only matching namespaces. By default all namespaces except the system namespace will have injection enabled. | `any` | `null` | no |
| connect\_inject\_priority\_class | Pod Priority Class for Connect Inject | `string` | `""` | no |
| connect\_inject\_resources | Resources for connect inject pod | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| connect\_inject\_sidecar\_proxy\_resources | Set default resources for sidecar proxy. If null, that resource won't be set. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| connect\_inject\_tolerations | Template string for Connect Inject Tolerations | `string` | `""` | no |
| consul\_domain | Top level Consul domain for DNS queries | `string` | `"consul"` | no |
| consul\_image\_name | Docker Image of Consul to run | `string` | `"consul"` | no |
| consul\_image\_tag | Docker image tag of Consul to run | `string` | `"1.9.0"` | no |
| consul\_k8s\_image | Docker image of the consul-k8s binary to run | `string` | `"hashicorp/consul-k8s"` | no |
| consul\_k8s\_tag | Image tag of the consul-k8s binary to run | `string` | `"0.21.0"` | no |
| consul\_template\_image | Image for Consul Template | `string` | `"hashicorp/consul-template:0.25.1-light"` | no |
| controller\_enable | Enable Consul Configuration Entries CRD Controller | `bool` | `false` | no |
| controller\_log\_level | CRD Controller Log level. | `string` | `"info"` | no |
| controller\_node\_affinity | YAML string for Controller affinity | `any` | `null` | no |
| controller\_node\_selector | YAML string for Controller Node Selector | `any` | `null` | no |
| controller\_node\_tolerations | YAML string for Controller tolerations | `any` | `null` | no |
| controller\_priority\_class | Priority class for Controller pods | `string` | `""` | no |
| controller\_resources | CRD Controller resources | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| core\_dns\_labels | Labels for CoreDNS ConfigMap | `map` | <pre>{<br>  "addonmanager.kubernetes.io/mode": "EnsureExists",<br>  "eks.amazonaws.com/component": "coredns",<br>  "k8s-app": "kube-dns"<br>}</pre> | no |
| core\_dns\_template | Template for CoreDNS `CoreFile` configuration. Use Terraform string interpolation format with the variable `consul_dns_address` for Consul DNS endpoint. See Default for an example | `string` | `".:53 {\n  errors\n  health\n  kubernetes cluster.local in-addr.arpa ip6.arpa {\n    pods insecure\n    upstream\n    fallthrough in-addr.arpa ip6.arpa\n  }\n  prometheus :9153\n  forward . /etc/resolv.conf\n  cache 30\n  loop\n  reload\n  loadbalance\n}\n\nconsul {\n  errors\n  cache 30\n  forward . ${consul_dns_address}\n}\n"` | no |
| enable\_connect\_inject | Enable Connect Injector process | `bool` | `false` | no |
| enable\_esm | Enable Consul ESM deployment | `bool` | `false` | no |
| enable\_exporter | Enable Consul Exporter deployment | `bool` | `false` | no |
| enable\_sync\_catalog | Enable Service catalog sync: https://www.consul.io/docs/platform/k8s/service-sync.html | `bool` | `true` | no |
| enable\_ui | Enable Consul UI | `bool` | `false` | no |
| envoy\_extra\_args | Pass arguments to the injected envoy sidecar. Valid arguments to pass to envoy can be found here: https://www.envoyproxy.io/docs/envoy/latest/operations/cli | `any` | `null` | no |
| esm\_affinity | Affinity for ESM | `map` | `{}` | no |
| esm\_chart\_name | Name of the ESM Chart name | `string` | `"consul-esm"` | no |
| esm\_chart\_repository | ESM Chart repository | `string` | `"https://basisai.github.io/charts/"` | no |
| esm\_chart\_version | ESM Chart version | `string` | `"0.2.2"` | no |
| esm\_env | Environment variables for Consul ESM | `list` | `[]` | no |
| esm\_external\_node\_meta | The node metadata values used for the ESM to qualify a node in the catalog as an "external node". | `map` | <pre>{<br>  "external-node": "true"<br>}</pre> | no |
| esm\_http\_addr | HTTP address of the local Consul agent | `string` | `""` | no |
| esm\_image | Docker image for ESM | `string` | `"basisai/consul-esm"` | no |
| esm\_init\_container\_set\_sysctl | Enable setting sysctl settings via a privileged container to allow pings | `bool` | `false` | no |
| esm\_kv\_path | The directory in the Consul KV store to use for storing ESM runtime data. | `string` | `"consul-esm/"` | no |
| esm\_log\_level | Log level for ESM | `string` | `"INFO"` | no |
| esm\_node\_agent\_port | Override port for Consul agent Daemonset | `any` | `null` | no |
| esm\_node\_probe\_interval | The interval to ping and update coordinates for external nodes that have 'external-probe' set to true. By default, ESM will attempt to ping and  update the coordinates for all nodes it is watching every 10 seconds. | `string` | `"10s"` | no |
| esm\_node\_reconnect\_timeout | The length of time to wait before reaping an external node due to failed pings. | `string` | `"72h"` | no |
| esm\_ping\_type | The method to use for pinging external nodes. | `string` | `"udp"` | no |
| esm\_release\_name | Name of the ESM Chart Release | `string` | `"consul-esm"` | no |
| esm\_replica | Number of ESM replica | `number` | `3` | no |
| esm\_resources | Resources for ESM | `map` | <pre>{<br>  "limits": {<br>    "memory": "256Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m"<br>  }<br>}</pre> | no |
| esm\_server\_address | Override Consul Server address for TLS when using Auto Encrypt | `any` | `null` | no |
| esm\_server\_port | Override Consul Server port for TLS when using Auto Encrypt | `any` | `null` | no |
| esm\_service\_name | ESM service name in Consul | `string` | `"consul-esm"` | no |
| esm\_service\_tag | Service tag for ESM | `string` | `""` | no |
| esm\_tag | Docker Image tag for ESM | `string` | `"0.4.0"` | no |
| esm\_tolerations | Toleration for ESM | `list` | `[]` | no |
| esm\_use\_node\_agent | Use Consul agent Daemonset | `bool` | `true` | no |
| exporter\_affinity | Affinity for Consul Exporter | `map` | `{}` | no |
| exporter\_chart\_name | Name of the Consul Exporter Chart name | `string` | `"prometheus-consul-exporter"` | no |
| exporter\_chart\_repository | Consul Exporter Chart repository | `string` | `"https://prometheus-community.github.io/helm-charts"` | no |
| exporter\_chart\_version | Consul Exporter Chart version | `string` | `"0.2.0"` | no |
| exporter\_env | Additional Environment Variables for Exporter | `list` | `[]` | no |
| exporter\_extra\_containers | Extra extra Containers | `list` | `[]` | no |
| exporter\_extra\_volume\_mounts | Extra volume mounts for Exporter | `list` | `[]` | no |
| exporter\_extra\_volumes | Extra volumes for Exporter | `list` | `[]` | no |
| exporter\_image | Docker image for Consul Exporter | `string` | `"prom/consul-exporter"` | no |
| exporter\_init\_containers | Extra Init Containers | `list` | `[]` | no |
| exporter\_options | Arguments for Exporter. See https://github.com/prometheus/consul_exporter#flags | `map` | `{}` | no |
| exporter\_psp | Create PSP resources for Exporter | `bool` | `true` | no |
| exporter\_rbac\_enabled | Create RBAC resources for Exporter | `bool` | `true` | no |
| exporter\_release\_name | Name of the Consul Exporter Chart Release | `string` | `"consul-exporter"` | no |
| exporter\_replica | Number of Consul Exporter replicas | `number` | `1` | no |
| exporter\_resources | Resources for Consul Exporter | `map` | <pre>{<br>  "limits": {<br>    "memory": "256Mi"<br>  },<br>  "requests": {<br>    "cpu": "200m"<br>  }<br>}</pre> | no |
| exporter\_service\_annotations | Consul Exporter service's annotations | `map` | `{}` | no |
| exporter\_tag | Docker Image tag for Consul Exporter | `string` | `"v0.7.1"` | no |
| exporter\_tolerations | Tolerations for Consul Exporter | `list` | `[]` | no |
| fullname\_override | Fullname Override of Helm resources | `string` | `""` | no |
| gossip\_encryption\_key | 32 Bytes Base64 Encoded Consul Gossip Encryption Key. Set to `null` to disable | `any` | `null` | no |
| image\_envoy | Image and tag for Envoy Docker image to use for sidecar proxies, mesh, terminating and ingress gateways | `string` | `"envoyproxy/envoy-alpine:v1.16.0"` | no |
| inject\_health\_check | Enables the Consul Health Check controller which syncs the readiness status of connect-injected pods with Consul. | `bool` | `true` | no |
| inject\_health\_check\_reconcile\_period | defines how often a full state reconcile is done after the initial reconcile at startup is completed. | `string` | `"1m"` | no |
| lifecycle\_sidecar\_container\_resources | Resource settings for lifecycle-sidecar containers.<br>The lifecycle sidecar ensures the Consul services are always registered with<br>their local consul clients and is used by the ingress/terminating/mesh gateways<br>as well as with every connect-injected service. | `map` | <pre>{<br>  "limits": {<br>    "cpu": "20m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "20m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| max\_history | Max History for Helm | `number` | `20` | no |
| name | Sets the prefix used for all resources in the helm chart. If not set, the prefix will be "<helm release name>-consul". | `any` | `null` | no |
| pod\_security\_policy\_enable | Create PodSecurityPolicy Resources | `bool` | `true` | no |
| release\_name | Helm release name for Consul | `string` | `"consul"` | no |
| secret\_annotation | Annotations for the Consul Secret | `map` | `{}` | no |
| secret\_name | Name of the secret for Consul | `string` | `"consul"` | no |
| server\_affinity | A YAML string that can be templated via helm specifying the affinity for server pods | `string` | `"podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          app: {{ template \"consul.name\" . }}\n          release: \"{{ .Release.Name }}\"\n          component: server\n      topologyKey: kubernetes.io/hostname\n"` | no |
| server\_annotations | A YAML string for server pods | `string` | `""` | no |
| server\_datacenter | Datacenter to configure Consul as. | `any` | n/a | yes |
| server\_extra\_config | Additional configuration to include for servers in JSON/HCL | `map` | `{}` | no |
| server\_extra\_volumes | List of map of extra volumes specification for server pods. See https://www.consul.io/docs/platform/k8s/helm.html#v-server-extravolumes for the keys | `list` | `[]` | no |
| server\_priority\_class | Priority class for servers | `string` | `""` | no |
| server\_replicas | Number of server replicas to run | `number` | `5` | no |
| server\_resources | Resources for server | `map` | <pre>{<br>  "limits": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  },<br>  "requests": {<br>    "cpu": "100m",<br>    "memory": "100Mi"<br>  }<br>}</pre> | no |
| server\_storage | This defines the disk size for configuring the servers' StatefulSet storage. For dynamically provisioned storage classes, this is the desired size. For manually defined persistent volumes, this should be set to the disk size of the attached volume. | `string` | `"10Gi"` | no |
| server\_storage\_class | The StorageClass to use for the servers' StatefulSet storage. It must be able to be dynamically provisioned if you want the storage to be automatically created. For example, to use Local storage classes, the PersistentVolumeClaims would need to be manually created. An empty value will use the Kubernetes cluster's default StorageClass. | `string` | `""` | no |
| server\_tolerations | A YAML string that can be templated via helm specifying the tolerations for server pods | `string` | `""` | no |
| sync\_add\_k8s\_namespace\_suffix | Appends Kubernetes namespace suffix to each service name synced to Consul, separated by a dash. | `bool` | `true` | no |
| sync\_affinity | YAML template string for Sync Catalog affinity | `string` | `""` | no |
| sync\_by\_default | If true, all valid services in K8S are synced by default. If false, the service must be annotated properly to sync. In either case an annotation can override the default. | `bool` | `true` | no |
| sync\_cluster\_ip\_services | If true, will sync Kubernetes ClusterIP services to Consul. This can be disabled to have the sync ignore ClusterIP-type services. | `bool` | `true` | no |
| sync\_k8s\_prefix | A prefix to prepend to all services registered in Kubernetes from Consul. This defaults to '' where no prefix is prepended; Consul services are synced with the same name to Kubernetes. (Consul -> Kubernetes sync only) | `string` | `""` | no |
| sync\_k8s\_tag | An optional tag that is applied to all of the Kubernetes services that are synced into Consul. If nothing is set, this defaults to 'k8s'. (Kubernetes -> Consul sync only) | `string` | `"k8s"` | no |
| sync\_node\_port\_type | Configures the type of syncing that happens for NodePort services. The only valid options are: ExternalOnly, InternalOnly, and ExternalFirst. ExternalOnly will only use a node's ExternalIP address for the sync, otherwise the service will not be synced. InternalOnly uses the node's InternalIP address. ExternalFirst will preferentially use the node's ExternalIP address, but if it doesn't exist, it will use the node's InternalIP address instead. | `string` | `""` | no |
| sync\_priority\_class | Priority Class Name for Consul Sync Catalog | `string` | `""` | no |
| sync\_resources | Sync Catalog resources | `map` | <pre>{<br>  "limits": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  },<br>  "requests": {<br>    "cpu": "50m",<br>    "memory": "50Mi"<br>  }<br>}</pre> | no |
| sync\_to\_consul | If true, will sync Kubernetes services to Consul. This can be disabled to have a one-way sync. | `bool` | `true` | no |
| sync\_to\_k8s | If true, will sync Consul services to Kubernetes. This can be disabled to have a one-way sync. | `bool` | `true` | no |
| sync\_tolerations | Template string for Sync Catalog Tolerations | `string` | `""` | no |
| terminating\_gateway\_defaults | Terminating Gateway defaults.<br>You can override any of these fields under `terminating_gateways`.<br>Annotations are concatenated<br><br>Note: You do not have to specify all of the fields to override them. If you omit them, they will<br>fall back to the defaults for the Helm Chart. | `map` | <pre>{<br>  "affinity": "podAntiAffinity:\n  requiredDuringSchedulingIgnoredDuringExecution:\n    - labelSelector:\n        matchLabels:\n          app: {{ template \"consul.name\" . }}\n          release: \"{{ .Release.Name }}\"\n          component: terminating-gateway\n      topologyKey: kubernetes.io/hostname\n",<br>  "annotations": null,<br>  "consulNamespace": "default",<br>  "extraVolumes": [],<br>  "initCopyConsulContainer": {<br>    "resources": {<br>      "limits": {<br>        "cpu": "50m",<br>        "memory": "25Mi"<br>      },<br>      "requests": {<br>        "cpu": "50m",<br>        "memory": "25Mi"<br>      }<br>    }<br>  },<br>  "nodeSelector": null,<br>  "priorityClassName": "",<br>  "replicas": 2,<br>  "resources": {<br>    "limits": {<br>      "cpu": "100Mi",<br>      "memory": "100Mi"<br>    },<br>    "requests": {<br>      "cpu": "100Mi",<br>      "memory": "100Mi"<br>    }<br>  },<br>  "tolerations": null<br>}</pre> | no |
| terminating\_gateway\_enable | Deploy Terminating Gateways | `bool` | `false` | no |
| terminating\_gateways | Gateways is a list of gateway objects. The only required field for<br>each is `name`, though they can also contain any of the fields in<br>`terminating_gateway_defaults`. Values defined here override the defaults except in the<br>case of annotations where both will be applied. | `list` | <pre>[<br>  {<br>    "name": "terminating-gateway"<br>  }<br>]</pre> | no |
| tls\_ca | Self generated CA for Consul Server TLS. Values should be PEM encoded | <pre>object({<br>    cert = string,<br>    key  = string,<br>  })</pre> | `null` | no |
| tls\_enable\_auto\_encrypt | Enable auto encrypt. Uses the connect CA to distribute certificates to clients | `bool` | `false` | no |
| tls\_enabled | Enable TLS for the cluster | `bool` | `false` | no |
| tls\_https\_only | If true, Consul will disable the HTTP port on both clients and servers and only accept HTTPS connections. | `bool` | `true` | no |
| tls\_server\_additional\_dns\_sans | List of additional DNS names to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access the Consul server(s) externally, for example, if you're using the UI. | `list` | `[]` | no |
| tls\_server\_additional\_ip\_sans | List of additional IP addresses to set as Subject Alternative Names (SANs) in the server certificate. This is useful when you need to access Consul server(s) externally, for example, if you're using the UI. | `list` | `[]` | no |
| tls\_verify | If true, 'verify\_outgoing', 'verify\_server\_hostname', and<br>'verify\_incoming\_rpc' will be set to true for Consul servers and clients.<br>Set this to false to incrementally roll out TLS on an existing Consul cluster.<br>Note: remember to switch it back to true once the rollout is complete.<br>Please see this guide for more details:<br>https://learn.hashicorp.com/consul/security-networking/certificates | `bool` | `true` | no |
| ui\_additional\_spec | Additional Spec for the UI service | `string` | `""` | no |
| ui\_annotations | UI service annotations | `string` | `""` | no |
| ui\_service\_type | Type of service for Consul UI | `string` | `"ClusterIP"` | no |

## Outputs

| Name | Description |
|------|-------------|
| kube\_dns\_service\_cluster\_ip | Cluster IP of the Consul DNS service |
| release | Helm Release Object |
