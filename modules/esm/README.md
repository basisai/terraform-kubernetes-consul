# Consul ESM Deployment

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.consul_esm](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | Namespace to install the chart into | `string` | `"default"` | no |
| <a name="input_consul_k8s_image"></a> [consul\_k8s\_image](#input\_consul\_k8s\_image) | Docker image of the consul-k8s binary to run | `string` | `"hashicorp/consul-k8s-control-plane"` | no |
| <a name="input_consul_k8s_tag"></a> [consul\_k8s\_tag](#input\_consul\_k8s\_tag) | Image tag of the consul-k8s binary to run | `string` | `"0.34.1"` | no |
| <a name="input_consul_template_image"></a> [consul\_template\_image](#input\_consul\_template\_image) | Image for Consul Template | `string` | `"hashicorp/consul-template:0.26.0"` | no |
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
| <a name="input_esm_server_address"></a> [esm\_server\_address](#input\_esm\_server\_address) | Address for Consul Server | `string` | `"consul-server.svc"` | no |
| <a name="input_esm_server_port"></a> [esm\_server\_port](#input\_esm\_server\_port) | Override Consul Server port for TLS when using Auto Encrypt | `number` | `null` | no |
| <a name="input_esm_service_name"></a> [esm\_service\_name](#input\_esm\_service\_name) | ESM service name in Consul | `string` | `"consul-esm"` | no |
| <a name="input_esm_service_tag"></a> [esm\_service\_tag](#input\_esm\_service\_tag) | Service tag for ESM | `string` | `""` | no |
| <a name="input_esm_tag"></a> [esm\_tag](#input\_esm\_tag) | Docker Image tag for ESM | `string` | `"0.6.0"` | no |
| <a name="input_esm_tolerations"></a> [esm\_tolerations](#input\_esm\_tolerations) | Toleration for ESM | `any` | `[]` | no |
| <a name="input_esm_use_node_agent"></a> [esm\_use\_node\_agent](#input\_esm\_use\_node\_agent) | Use Consul agent Daemonset | `bool` | `true` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Max History for Helm | `number` | `20` | no |
| <a name="input_tls_cacert"></a> [tls\_cacert](#input\_tls\_cacert) | Self generated CA for Consul Server TLS. Values should be PEM encoded | `string` | `null` | no |
| <a name="input_tls_enable_auto_encrypt"></a> [tls\_enable\_auto\_encrypt](#input\_tls\_enable\_auto\_encrypt) | Enable auto encrypt. Uses the connect CA to distribute certificates to clients | `bool` | `false` | no |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | Enable TLS for the Consul cluster | `bool` | `false` | no |

## Outputs

No outputs.
