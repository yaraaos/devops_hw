variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

# Backend
variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform state"
  default     = "terraform-state-lesson-8-9-yara-goit-02"
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name for Terraform state locking"
  default     = "terraform-locks-lesson-8-9"
}

# VPC
variable "vpc_name" {
  type        = string
  description = "VPC name"
  default     = "lesson-7-vpc"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR"
  default     = "10.10.0.0/16"
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDRs"
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDRs"
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

# ECR
variable "ecr_name" {
  type        = string
  description = "ECR repository name"
  default     = "lesson-7-ecr"
}

variable "ecr_scan_on_push" {
  type        = bool
  description = "Enable scan on push"
  default     = true
}

# EKS
variable "eks_cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "lesson-7-eks"
}

variable "instance_type" {
  type        = string
  description = "Worker node instance type"
  default     = "t3.micro"
}

variable "desired_size" {
  type        = number
  description = "Desired worker nodes"
  default     = 4
}

variable "min_size" {
  type        = number
  description = "Min worker nodes"
  default     = 4
}

variable "max_size" {
  type        = number
  description = "Max worker nodes"
  default     = 6
}

variable "github_username" {
  type        = string
  description = "GitHub username used by Jenkins to push changes"
}

variable "github_pat" {
  type        = string
  description = "GitHub Personal Access Token (PAT) used by Jenkins"
  sensitive   = true
}

variable "helm_repo_url" {
  type        = string
  description = "Git repo URL that contains the Helm chart (Jenkins will update values.yaml tag there)"
}

variable "helm_repo_path" {
  type        = string
  description = "Path inside helm repo where chart is located (example: django-chart)"
  default     = "django-chart"
}

variable "helm_repo_revision" {
  type        = string
  description = "Branch/tag ArgoCD tracks (example: main)"
  default     = "main"
}
