variable "namespace" {
  type        = string
  description = "Namespace for monitoring stack"
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  type        = string
  description = "Helm chart version for prometheus"
  default     = ""
}

variable "grafana_chart_version" {
  type        = string
  description = "Helm chart version for grafana"
  default     = ""
}
