// update subnet id using data method to handle subnet id dynamic "subnet-id" you can find subnet under VPC it associate with VPC id base on vpc you can get subnets

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}
// other data provider get os image id dynamically
data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}
data "aws_ami_ids" "aws_linux_2_latest_ids" {
  owners = ["amazon"]
}