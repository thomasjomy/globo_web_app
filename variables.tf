variable "aws_access_key" {
  type        = string
  description = "AWS access key"
  sensitive   = true

}

variable "aws_secret_key" {
  type        = string
  description = "AWS access key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS access key"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR block for vpc"
  default     = "10.0.0.0/16"

}

variable "vpc_public_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR block for public subnets in vpc"
  default     = ["10.0.0.0/24", "10.0.0.0/24"]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Map a public ip address for subnet instance"
  default     = true
}

variable "ec2_instance_type" {
  type        = string
  description = "AWS EC2 instance type"
  default     = "t2.micro"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "Glbomantics"
}

variable "project" {
  type        = string
  description = "Projet name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}

