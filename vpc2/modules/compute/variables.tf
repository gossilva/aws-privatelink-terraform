variable "project_name" {
  type        = string
  description = "Default naming convention for vpc2 resources"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all AWS resources"
}

variable "vpc2_public_subnet_1a" {
  type        = string
  description = "Public subnet 1a to create resources."
}

variable "vpc2_public_subnet_1b" {
  type        = string
  description = "Public subnet 1b to create resources."
}

variable "vpc2_private_subnet_1a" {
  type        = string
  description = "Public subnet 1a to create resources."
}

variable "vpc_id" {
  type        = string
  description = "Value to query VPC id."
}