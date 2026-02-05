variable "namespace" { type = string }
variable "chart_version" { type = string }

variable "name" {
  type    = string
  default = "argo-cd"
}

variable "app_repo_url" { type = string }
variable "app_path" { type = string }
variable "app_revision" { type = string }
