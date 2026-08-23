terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# ---------------------------------------------------------------------------
# VPC - the shared network both jenkins-server and EKS live inside.
# We use the official community module instead of hand-writing ~10 resource
# blocks (subnets, route tables, IGW) - this is the industry-standard approach.
# ---------------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs            = ["${var.region}a", "${var.region}b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  # No private subnets / NAT Gateway for this learning build - keeps cost near zero.
  # In production you would add private_subnets + enable_nat_gateway = true and
  # move the EKS node group there. Flag this consciously in the interview.
  map_public_ip_on_launch = true

  # These tags let AWS auto-discover the subnets for Load Balancers created by
  # Kubernetes Services (type: LoadBalancer) later on - required, not optional.
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-eks" = "shared"
    "kubernetes.io/role/elb"                        = "1"
  }

  tags = {
    Project = var.project_name
  }
}

# ---------------------------------------------------------------------------
# jenkins-server - OUR OWN hand-written module (see modules/ec2-jenkins/)
# ---------------------------------------------------------------------------
module "jenkins" {
  source = "./modules/ec2-jenkins"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnets[0]
  instance_type    = var.jenkins_instance_type
  allowed_ssh_cidr = var.allowed_ssh_cidr
}

# ---------------------------------------------------------------------------
# EKS cluster - using the official community module. Hand-writing this module
# would be 15+ raw resource blocks (IAM roles, launch templates, ASG, addons) -
# the community module is what real teams use rather than reinventing it.
# ---------------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-eks"
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true   

  eks_managed_node_groups = {
    default = {
      instance_types = ["c7i-flex.large"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = {
    Project = var.project_name
  }
}
