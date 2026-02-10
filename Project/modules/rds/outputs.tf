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
