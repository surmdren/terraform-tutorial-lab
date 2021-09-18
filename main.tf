provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "app" {
  instance_type     = "t2.micro"
  availability_zone = "ap-northeast-1"
  ami               = "ami-02892a4ea9bfa2192"

  user_data = <<-EOF
              #!/bin/bash
              sudo service apache2 start
              EOF
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-lab-s3-state" 
  acl    = "private"
  
  versioning {
    enabled = true
  }
}

#terraform {
#  backend "s3" {
#    bucket = "terraform-lab-s3-state"
#    key    = "terraform/stage/terraform.tfstate"
#    region = "ap-northeast-1"
#  }
#}
