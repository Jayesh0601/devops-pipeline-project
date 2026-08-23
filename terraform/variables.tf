variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Prefix used to name/tag every resource, so they're easy to find and destroy"
  type        = string
  default     = "devops-pipeline"
}

variable "vpc_cidr" {
  description = "IP range for the whole VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "jenkins_instance_type" {
  description = "EC2 size for jenkins-server"
  type        = string
  default     = "c7i-flex.large"
}

variable "allowed_ssh_cidr" {
  description = "Who can SSH into jenkins-server. 0.0.0.0/0 = anyone (fine for short learning sessions, NOT for real use)"
  type        = string
  default     = "0.0.0.0/0"
}
