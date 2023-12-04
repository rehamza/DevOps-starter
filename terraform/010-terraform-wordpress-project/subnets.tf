
# Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc_wordpress.id
  cidr_block        = "15.0.128.0/20"
  availability_zone = "us-east-1a" # Change the availability zone as needed

  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet"
  }
}


#Certainly! Below is an example of how you can extend your Terraform script to create a VPC with one public subnet and one private subnet. Additionally, it includes the creation of an EC2 instance in each subnet – one for WordPress and one for MySQL.

# Create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_wordpress.id
  cidr_block        = "15.0.144.0/20"
  availability_zone = "us-east-1b" # Change the availability zone as needed

  tags = {
    Name = "Private Subnet"
  }
}

