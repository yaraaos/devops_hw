variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets for EKS"
}

variable "instance_type" {
  type        = string
  description = "Worker node instance type"
  default     = "t3.micro"
}

variable "desired_size" {
  type    = number
  default = 4
}

variable "min_size" {
  type    = number
  default = 4
}

variable "max_size" {
  type    = number
  default = 6
}
