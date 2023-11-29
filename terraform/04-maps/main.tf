variable "users" {
  #   default = {
  #    iam-user-11: "Netherland",
  #     iam-user-22: "Pakistan",
  #      iam-user-33: "US"
  #      }

  default = {
    iam-user-11 : { country : "Netherland" , department: "abc0"},
    iam-user-22 : { country : "Pakistan", department: "abc1" },
    iam-user-33 : { country : "US" , department: "abc2"}
  }
}


provider "aws" {
  region = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}


resource "aws_iam_user" "my_iam_users" {
  for_each = var.users
  name     = each.key
  tags = {
    # country : each.value
    country: each.value.country
    department: each.value.department
  }

}