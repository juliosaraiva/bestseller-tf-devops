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

variable "ebs_volume_size" {
  description = "Volume size to add into launch template"
  default     = 20
  type        = number
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t3.micro"
  type        = string
}

variable "ssh_key_name" {
  description = "The key name to use for the instance"
  type        = string
}

variable "monitoring_enabled" {
  description = "Enable monitoring for EC2 Instances"
  default     = true
  type        = bool
}

variable "vpc_id" {
  description = "Default VPC"
  type = string
}

variable "subnet_id" {
  description = "Subnet"
  type        = string
}

variable "min_size" {
  description = "The minimum size of the Auto Scaling Group."
  default = 1
  type = number
}

variable "max_size" {
  description = "The maximum size of the Auto Scaling Group."
  default = 2
  type = number
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group."
  default = 1
  type = number
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health."
  default = 300
  type = number
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in."
  type = list(string)
}

variable "health_check_type" {
  description = "'EC2' or 'ELB'. Controls how health checking is done."
  default = "EC2"
  type = string
}