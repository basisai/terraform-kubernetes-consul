# Deploy Consul Exporter for Prometheus
resource "helm_release" "consul_exporter" {
  name       = var.exporter_release_name
  chart      = var.exporter_chart_name
  repository = var.exporter_chart_repository
  version    = var.exporter_chart_version
  namespace  = var.chart_namespace

  max_history = var.max_history

  values = [
    templatefile("${path.module}/templates/exporter-values.yaml", local.values),
  ]
}

locals {
  exporter_volume = "consul-ca"

  exporter_server_ca_init = {
    name  = "server-ca"
    image = "alpine"
    volumeMounts = [
      {
        name      = local.exporter_volume
        mountPath = "/${local.exporter_volume}"
      },
    ]
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
    command = [
      "/bin/sh",
      "-ec",
      "echo ${base64encode(var.tls_cacert != null ? var.tls_cacert : "")} | base64 -d > /${local.exporter_volume}/server.pem"
    ]
  }

  exporter_consul_template = <<-EOF
    log_level = "debug"
    kill_signal = "SIGTERM"
    template {
      destination = "/${local.exporter_volume}/connect.pem"
    }
    # Re-render CA Root
    template {
      destination = "/output/connect.pem"
      left_delimiter = "<<"
      right_delimiter = ">>"
      contents = "<< range caRoots >><< .RootCertPEM >><< end >>"
    }
    EOF

  exporter_connect_init = {
    name  = "get-auto-encrypt-client-ca"
    image = "${var.consul_k8s_image}:${var.consul_k8s_tag}"
    volumeMounts = [
      {
        name      = local.exporter_volume
        mountPath = "/${local.exporter_volume}"
      },
    ]
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

    command = [
      "/bin/sh",
      "-ec",
      <<-EOF
      echo "${base64encode(local.exporter_consul_template)}"  | base64 -d > /${local.exporter_volume}/consul_template.hcl \
      && consul-k8s-control-plane get-consul-client-ca \
        -output-file=/${local.exporter_volume}/connect.pem \
        ${var.tls_cacert != null ? "-ca-file=/${local.exporter_volume}/server.pem \\" : ""}
        -server-addr=${var.consul_server_address} \
        -server-port=8501
      EOF
    ]
  }

  exporter_connect = {
    name  = "consul-template"
    image = var.consul_template_image
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
    volumeMounts = [
      {
        name      = local.exporter_volume
        mountPath = "/${local.exporter_volume}"
      },
    ]
    env = [
      {
        name = "HOST_IP"
        valueFrom = {
          fieldRef = {
            fieldPath = "status.hostIP"
          }
        }
      },
    ]
  }
  command = ["/bin/consul-template"]
  args = compact([
    "-consul-addr=$(HOST_IP):8501",
    "-consul-ssl=true",
    var.tls_cacert != null ? "-consul-ssl-ca-cert=/${local.exporter_volume}/server.pem" : "",
    "-config=/${local.exporter_volume}/consul_template.hcl",
  ])

  values = {
    replica = var.exporter_replica
    image   = var.exporter_image
    tag     = var.exporter_tag

    resources   = jsonencode(var.exporter_resources)
    affinity    = jsonencode(var.exporter_affinity)
    tolerations = jsonencode(var.exporter_tolerations)

    options = jsonencode(merge(var.exporter_options, {
      "consul.ca-file" = var.tls_enable_auto_encrypt ? "/${local.exporter_volume}/connect.pem" : (var.tls_cacert != null ? "/${local.exporter_volume}/server.pem" : "")
    }))

    rbac_enabled            = var.exporter_rbac_enabled
    psp_enabled             = var.exporter_psp
    service_monitor_enabled = var.exporter_service_monitor

    consul_server_and_port = "${var.tls_enabled ? "https://" : ""}$(HOST_IP):${var.tls_enabled ? "8501" : "8500"}"

    service_annotations = jsonencode(var.exporter_service_annotations)

    extra_volumes = jsonencode(concat(var.exporter_extra_volumes, [
      {
        name = local.exporter_volume
        emptyDir = {
          medium = "Memory"
        }
      },
    ]))

    extra_volume_mounts = jsonencode(concat(var.exporter_extra_volume_mounts, [
      {
        name      = local.exporter_volume
        mountPath = "/${local.exporter_volume}"
      }
    ]))

    env = jsonencode(concat(var.exporter_env, [
      {
        name = "HOST_IP"
        valueFrom = {
          fieldRef = {
            fieldPath = "status.hostIP"
          }
        }
      },
    ]))


    init_containers = jsonencode(concat(var.exporter_init_containers,
      var.tls_enabled && var.tls_cacert != null ? [local.exporter_server_ca_init] : [],
      var.tls_enabled && var.tls_enable_auto_encrypt ? [local.exporter_connect_init] : [],
    ))

    extra_containers = jsonencode(concat(var.exporter_extra_containers,
      var.tls_enabled && var.tls_enable_auto_encrypt ? [local.exporter_connect] : [],
    ))

    pod_annotations = jsonencode(var.exporter_pod_annotations)
  }
}
