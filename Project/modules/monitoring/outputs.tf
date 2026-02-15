output "grafana_port_forward_cmd" {
  value = "kubectl -n monitoring port-forward svc/grafana 3000:80"
}

output "grafana_admin_user" {
  value = "admin"
}

output "grafana_admin_password" {
  value = "admin"
}

output "prometheus_port_forward_cmd" {
  value = "kubectl -n monitoring port-forward svc/prometheus-server 9090:80"
}
