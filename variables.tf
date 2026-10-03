variable "aws_region" {
  description = "AWS region where the infrastructure is located"
  type        = string
}

variable "project_id" {
  description = "Project identifier used for resource names and tags"
  type        = string
}

variable "allowed_ip_range" {
  description = "List of IP ranges allowed to access the infrastructure"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "public_instance_id" {
  description = "ID of the existing public EC2 instance"
  type        = string
}

variable "private_instance_id" {
  description = "ID of the existing private EC2 instance"
  type        = string
}
