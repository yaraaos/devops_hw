resource "kubernetes_namespace" "argocd" {
  metadata { name = var.namespace }
}

resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  timeout    = 1800
  wait       = true
  atomic     = false

  values = [file("${path.module}/values.yaml")]

  create_namespace = false
}

# Helm chart that creates ArgoCD Application(s)
resource "helm_release" "argo_apps" {
  name             = "${var.name}-apps"
  chart            = "${path.module}/charts"
  namespace        = kubernetes_namespace.argocd.metadata[0].name
  create_namespace = false

  values = [
    templatefile("${path.module}/charts/values.yaml", {
      app_repo_url  = var.app_repo_url
      app_path      = var.app_path
      app_revision  = var.app_revision
      app_namespace = "default"
    })
  ]

  depends_on = [helm_release.argo_cd]
}
