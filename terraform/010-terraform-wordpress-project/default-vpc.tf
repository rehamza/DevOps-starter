# Create default VPC
resource "aws_default_vpc" "default" {}

resource "aws_vpc" "vpc_wordpress" {

  cidr_block           = "15.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "master-vpc-wordpress"
  }

}
