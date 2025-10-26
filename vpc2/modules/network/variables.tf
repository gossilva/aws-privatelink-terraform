variable "cidr_block" {
  type        = string
  description = "CIDR block value to create VPC."
}

variable "project_name" {
  type        = string
  description = "Default naming convention for vpc2 resources"
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to add to all AWS resources"
}