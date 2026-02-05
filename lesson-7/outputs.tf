output "s3_bucket_name" {
  value = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  value = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "internet_gateway_id" {
  value = module.vpc.internet_gateway_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "jenkins_admin_password_cmd" {
  value = module.jenkins.jenkins_admin_password_cmd
}

output "argocd_url" {
  value = module.argo_cd.argocd_url
}

output "argocd_admin_password_cmd" {
  value = module.argo_cd.argocd_admin_password_cmd
}
