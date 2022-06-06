locals {
  cluster_name = "education-eks-${random_string.suffix.result}"
}


# Maintenance VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "172.19.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge({ Name = "${var.region}-${var.service_name}-vpc" })
}

resource "aws_subnet" "jenkins" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 12, count.index + 2)
  availability_zone       = local.availability_zones[var.region][count.index]
  map_public_ip_on_launch = false
  depends_on              = [aws_vpc.vpc]

  tags = merge({ Name = "${var.region}-${var.service_name}-public-jenkins-${count.index}" })

}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


# Application VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  create_vpc           = false
  name                 = "education-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}