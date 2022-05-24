provider "aws" {
  region = "ap-northeast-1"
}

data "aws_availability_zones" "available" {}

resource "aws_instance" "app" {
  count             = "0"
  instance_type     = "t2.micro"
  ami               = "ami-02892a4ea9bfa2192"

  user_data = <<-EOF
              #!/bin/bash
              sudo service apache2 start
              EOF
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-lab-s3-state" 
  acl    = "private"
  
  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = true
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-lab-s3-state"
    key    = "terraform/stage/terraform.tfstate"
    region = "ap-northeast-1"
  }
}


variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "service_name" {
  type    = string
  default = "mysvc"
}

locals {
  availability_zones = {
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
  }
}
