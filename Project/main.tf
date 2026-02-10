terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.state_bucket_name
  table_name  = var.lock_table_name
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = var.vpc_cidr_block
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  availability_zones = var.availability_zones
  vpc_name           = var.vpc_name
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = var.ecr_name
  scan_on_push = var.ecr_scan_on_push
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.eks_cluster_name
  subnet_ids   = module.vpc.public_subnets

  instance_type = var.instance_type
  desired_size  = var.desired_size
  min_size      = var.min_size
  max_size      = var.max_size
}

# --- Connect Terraform -> EKS ---

data "aws_eks_cluster" "eks" {
  name = module.eks.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

provider "kubernetes" {
  host = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(
    data.aws_eks_cluster.eks.certificate_authority[0].data
  )
  token = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes = {
    host = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(
      data.aws_eks_cluster.eks.certificate_authority[0].data
    )
    token = data.aws_eks_cluster_auth.eks.token
  }
}


# --- Jenkins (Helm via Terraform) ---
module "jenkins" {
  source             = "./modules/jenkins"
  cluster_name       = module.eks.eks_cluster_name
  region             = var.aws_region
  ecr_repository_url = module.ecr.repository_url

  github_username = var.github_username
  github_pat      = var.github_pat

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

# --- Argo CD (Helm via Terraform) ---
module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.46.4"

  app_repo_url = var.helm_repo_url
  app_path     = var.helm_repo_path
  app_revision = var.helm_repo_revision

  providers = {
    helm       = helm
    kubernetes = kubernetes
  }
}

# --- RDS ---
module "rds" {
  source = "./modules/rds"

  name       = "myapp-db"
  use_aurora = var.use_aurora

  # Standard RDS
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "myapp"
  username          = "postgres"
  password          = var.db_password

  vpc_id                  = module.vpc.vpc_id
  subnet_private_ids      = module.vpc.private_subnets
  subnet_public_ids       = module.vpc.public_subnets
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 1

  allowed_cidr_blocks = ["0.0.0.0/0"]

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

