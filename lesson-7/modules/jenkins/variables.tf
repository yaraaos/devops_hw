variable "cluster_name" { type = string }
variable "region" { type = string }
variable "ecr_repository_url" { type = string }

variable "github_username" { type = string }
variable "github_pat" {
  type      = string
  sensitive = true
}
