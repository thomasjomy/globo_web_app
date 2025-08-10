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

