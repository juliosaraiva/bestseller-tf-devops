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

variable "avail_zone" {
  description = "Default Zone"
  default     = "us-east-1"
  type        = string
}

variable "vpc_cidr_block" {
  description = "Default VPC CIDR"
  default     = "10.10.0.0/16"
  type        = string
}

variable "enable_dns_support" {
  description = "enable/disable DNS support in the VPC"
  default     = true
  type        = bool
}

variable "enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  default     = true
  type        = bool
}

variable "cidr_block_private_a" {
  default = "10.10.16.0/20"
  type    = string
}

variable "cidr_block_public_a" {
  default = "10.10.96.0/20"
  type    = string
}
