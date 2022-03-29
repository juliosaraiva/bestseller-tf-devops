variable "prefix" {
  description = "Prefix to attach into tag Name"
  default     = "bestseller"
  type        = string
}


variable "common_tags" {
  description = "Common Tags Used"
  default = {
    Environment = "development"
    ManagedBy   = "Terraform"
  }
  type = object({
    Environment = string
    ManagedBy   = string
  })
}

variable "public_subnets" {
  description = "List of all public subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID Provisioned by Terraform"
  type        = string
}

variable "internal" {
  description = "Set true if ALB should be internal only"
  default     = false
  type        = bool
}