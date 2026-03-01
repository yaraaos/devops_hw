output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_node_role_arn" {
  value = aws_iam_role.nodes.arn
}

output "node_security_group_id" {
  description = "Cluster shared security group used by nodes (cluster security group)"
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
}
