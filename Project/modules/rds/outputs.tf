output "subnet_group_name" {
  value       = aws_db_subnet_group.default.name
  description = "DB subnet group name"
}

output "security_group_id" {
  value       = aws_security_group.rds.id
  description = "Security group ID for DB"
}

output "endpoint" {
  description = "DB endpoint (RDS endpoint or Aurora endpoint)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].address
}

output "port" {
  description = "DB port"
  value       = var.db_port
}

output "engine_effective" {
  description = "Effective engine in use"
  value       = var.use_aurora ? var.engine_cluster : var.engine
}

output "db_endpoint" {
  description = "RDS endpoint (Aurora endpoint if use_aurora=true, otherwise standard RDS address)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : aws_db_instance.standard[0].address
}

output "db_port" {
  description = "RDS port"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].port : aws_db_instance.standard[0].port
}

output "db_security_group_id" {
  description = "Security group ID attached to RDS"
  value       = aws_security_group.rds.id
}

output "db_subnet_group_name" {
  description = "Subnet group name for RDS"
  value       = aws_db_subnet_group.default.name
}

output "db_engine_effective" {
  description = "Effective DB engine (standard or aurora)"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].engine : aws_db_instance.standard[0].engine
}
