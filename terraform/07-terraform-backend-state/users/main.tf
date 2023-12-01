variable "applicaiton_nanme" {
  default = "07-backend-state"
}

variable "project_name" {
  default = "users"
}

variable "environment" {
  default = "dev"
}

terraform {
  backend "s3" {

    bucket         = "dev-applications-backend-state-reham11"
    key            = "07-backend-state-users-dev"
    region         = "us-east-1"
    dynamodb_table = "dev_application_locks"
    encrypt        = true

  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "my_iam_user" {
  name = "${terraform.workspace}-new-user-22"
}
