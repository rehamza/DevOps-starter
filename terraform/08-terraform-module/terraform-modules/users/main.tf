
variable "environment" {
  default = "default"
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  name = "${local.iam_user_extenstion}-${var.environment}"
}


locals {
  iam_user_extenstion = "new-user-22"
}