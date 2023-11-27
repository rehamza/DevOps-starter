provider "aws" {
  region = "us-east-1"
}

# plan = command
# apply = execute cmd 

resource "aws_s3_bucket" "my_s3_buckets" {
  bucket = "re-user-118-8"
}

resource "aws_iam_user" "my_iam_user" {
  name = "my-iam-user-11-1-abc"
}