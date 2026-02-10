variable "name" {
  description = "Base name for DB resources (instance/cluster, subnet group, sg, parameter groups)"
  type        = string
}

variable "use_aurora" {
  description = "If true -> create Aurora cluster. If false -> create standard RDS instance."
  type        = bool
  default     = false
}

# ---------- Common networking ----------
variable "vpc_id" {
  description = "VPC ID where DB will be created"
  type        = string
}

variable "subnet_private_ids" {
  description = "Private subnet IDs"
  type        = list(string)
  default     = []
}

variable "subnet_public_ids" {
  description = "Public subnet IDs"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "If true -> use public subnets and allow public endpoint. If false -> private."
  type        = bool
  default     = false
}

variable "db_port" {
  description = "DB port (Postgres 5432, MySQL 3306)"
  type        = number
  default     = 5432
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to connect to DB port"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# ---------- Credentials / DB ----------
variable "db_name" {
  description = "Default database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password (SENSITIVE). Do not hardcode in git."
  type        = string
  sensitive   = true
}

# ---------- Standard RDS (non-aurora) ----------
variable "engine" {
  description = "RDS engine for standard instance (postgres/mysql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version for standard instance (e.g. 17.2 for postgres)"
  type        = string
  default     = "17.2"
}

variable "parameter_group_family_rds" {
  description = "Parameter group family for standard RDS (e.g. postgres17, mysql8.0)"
  type        = string
  default     = "postgres17"
}

variable "allocated_storage" {
  description = "Allocated storage for standard RDS (GB)"
  type        = number
  default     = 20
}

variable "instance_class" {
  description = "Instance class for DB (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Enable Multi-AZ for standard RDS"
  type        = bool
  default     = false
}

# ---------- Aurora ----------
variable "engine_cluster" {
  description = "Aurora engine (aurora-postgresql or aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version_cluster" {
  description = "Aurora engine version (e.g. 15.3 for aurora-postgresql)"
  type        = string
  default     = "15.3"
}

variable "parameter_group_family_aurora" {
  description = "Parameter group family for Aurora (e.g. aurora-postgresql15)"
  type        = string
  default     = "aurora-postgresql15"
}

variable "aurora_replica_count" {
  description = "How many Aurora reader instances to create"
  type        = number
  default     = 1
}

# ---------- Backups / parameters / tags ----------
variable "backup_retention_period" {
  description = "Backup retention days (0 disables backups)"
  type        = number
  default     = 1
}

variable "parameters" {
  description = "DB parameters to set in parameter group"
  type        = map(string)
  default     = {
    max_connections            = "200"
    log_min_duration_statement = "500"
    work_mem                   = "4096"
  }
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
