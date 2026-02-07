output "jenkins_url" {
  value = "Run: kubectl -n jenkins get svc jenkins -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}

output "jenkins_admin_password_cmd" {
  value = "kubectl -n jenkins get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d; echo"
}

