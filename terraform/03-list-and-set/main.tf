variable "names" {
  default = ["iam-user-000", "iam-user-00", "iam-user-11", "iam-user-22", "iam-user-33"]
}


provider "aws" {
  region = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}


resource "aws_iam_user" "my_iam_users" {
  #   count = length(var.names)
  #   name  = var.names[count.index]

  for_each = toset(var.names)
  name     = each.value

}