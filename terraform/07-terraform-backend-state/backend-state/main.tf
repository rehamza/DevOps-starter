provider "aws" {
  region = "us-east-1"
}


// s3 bucket

resource "aws_s3_bucket" "enterprise_backend_state" {
  bucket = "dev-applications-backend-state-reham11"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.enterprise_backend_state.id
  versioning_configuration {
    status = "Enabled"
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.enterprise_backend_state.id
  rule {

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }

  }
}

// Locking   we use locking we might have multiple people executing on same time and we don't want state to be corrupted => we can use for locking
// dynamoDB and it is a most popular DB of AWS dynamoDB support locks  

resource "aws_dynamodb_table" "enterprise_backend_lock" {

  name         = "dev_application_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// so using s3 everything will be encrypted just pass true flag