variable "project_name" {
  type = string
}

variable "vpc_id" {
  description = "Passed in from the VPC module's output"
  type        = string
}

variable "subnet_id" {
  description = "Passed in from the VPC module's output"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}
