resource "kubernetes_namespace" "jenkins" {
  metadata { name = "jenkins" }
}

resource "kubernetes_storage_class_v1" "ebs_sc" {
  metadata {
    name = "ebs-sc"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner  = "ebs.csi.aws.com"
  reclaim_policy       = "Delete"
  volume_binding_mode  = "WaitForFirstConsumer"

  parameters = {
    type = "gp3"
  }
}

# Secret that stores GitHub creds
resource "kubernetes_secret_v1" "github_token" {
  metadata {
    name      = "github-token"
    namespace = kubernetes_namespace.jenkins.metadata[0].name
  }

  type = "Opaque"

  data = {
    username = base64encode(var.github_username)
    token    = base64encode(var.github_pat)
  }
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = kubernetes_namespace.jenkins.metadata[0].name
  repository       = "https://charts.jenkins.io"
  chart            = "jenkins"
  version          = "5.8.27"
  create_namespace = false

  values = [
    file("${path.module}/values.yaml")
  ]

  depends_on = [
    kubernetes_storage_class_v1.ebs_sc,
    kubernetes_secret_v1.github_token
  ]
}
