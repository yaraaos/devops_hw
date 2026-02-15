resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  version    = var.prometheus_chart_version != "" ? var.prometheus_chart_version : null

  values = [
    file("${path.module}/values-prometheus.yaml")
  ]

  timeout = 1800
  wait    = true
  atomic  = false

  depends_on = [kubernetes_namespace_v1.monitoring]
}

resource "helm_release" "grafana" {
  name       = "grafana"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_chart_version != "" ? var.grafana_chart_version : null

  values = [
    file("${path.module}/values-grafana.yaml")
  ]

  timeout = 1800
  wait    = true
  atomic  = false

  depends_on = [kubernetes_namespace_v1.monitoring]
}
