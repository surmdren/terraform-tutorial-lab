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
  
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_acl" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

terraform {
  backend "s3" {
    bucket = "terraform-lab-s3-state"
    key    = "terraform/stage/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
