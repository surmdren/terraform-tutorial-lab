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
