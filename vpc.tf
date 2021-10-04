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