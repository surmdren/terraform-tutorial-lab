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

variable "ec2_instance" {
  type = map(object({
    ami_type = string
  }))
  default = {
    "ec2-1" = {
      ami_type = "t2.micro"
    }
    "ec2-2" = {
      ami_type = "t2.small"
    }
  }
}
