# Prometheus Consul Exporter

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
| [helm_release.consul_exporter](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_chart_namespace"></a> [chart\_namespace](#input\_chart\_namespace) | Namespace to install the chart into | `string` | `"default"` | no |
| <a name="input_consul_k8s_image"></a> [consul\_k8s\_image](#input\_consul\_k8s\_image) | Docker image of the consul-k8s binary to run | `string` | `"hashicorp/consul-k8s-control-plane"` | no |
| <a name="input_consul_k8s_tag"></a> [consul\_k8s\_tag](#input\_consul\_k8s\_tag) | Image tag of the consul-k8s binary to run | `string` | `"0.34.1"` | no |
| <a name="input_consul_server_address"></a> [consul\_server\_address](#input\_consul\_server\_address) | Address for Consul Server | `string` | `"consul-server.svc"` | no |
| <a name="input_consul_template_image"></a> [consul\_template\_image](#input\_consul\_template\_image) | Image for Consul Template | `string` | `"hashicorp/consul-template:0.26.0"` | no |
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
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Max History for Helm | `number` | `20` | no |
| <a name="input_tls_cacert"></a> [tls\_cacert](#input\_tls\_cacert) | Self generated CA for Consul Server TLS. Values should be PEM encoded | `string` | `null` | no |
| <a name="input_tls_enable_auto_encrypt"></a> [tls\_enable\_auto\_encrypt](#input\_tls\_enable\_auto\_encrypt) | Enable auto encrypt. Uses the connect CA to distribute certificates to clients | `bool` | `false` | no |
| <a name="input_tls_enabled"></a> [tls\_enabled](#input\_tls\_enabled) | Enable TLS for the Consul cluster | `bool` | `false` | no |

## Outputs

No outputs.
