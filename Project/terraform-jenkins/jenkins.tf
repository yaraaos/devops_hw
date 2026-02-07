resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  create_namespace = true

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"

  # Critical: don’t let Terraform hang on readiness in nano/flaky clusters
  wait    = false
  timeout = 1200

  values = [yamlencode({
    controller = {
      admin = {
        username = "admin"
        password = "admin12345"
      }

      serviceType = "ClusterIP"

      resources = {
        requests = { cpu = "200m", memory = "256Mi" }
        limits   = { cpu = "1000m", memory = "1Gi" }
      }

      installPlugins = [
        "kubernetes",
        "workflow-aggregator",
        "git",
        "credentials-binding"
      ]

      probes = {
        livenessProbe  = { initialDelaySeconds = 180 }
        readinessProbe = { initialDelaySeconds = 180 }
        startupProbe   = { initialDelaySeconds = 180 }
      }
    }

    persistence = { enabled = false }
    agent       = { enabled = true }
  })]
}
