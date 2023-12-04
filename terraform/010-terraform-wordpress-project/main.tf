provider "aws" {
  region = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}

# # Create an internet gateway for public subnet
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_default_vpc.default.id
# }

# Create MySQL EC2 instance in the private subnet
resource "aws_instance" "mysql_instance" {
  ami                    = data.aws_ami.aws_linux_2_latest.id # Replace with the appropriate MySQL AMI ID
  key_name               = "default-ec2-example"
  instance_type          = "t2.micro" # Choose instance type as needed
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]

  tags = {
    Name = "MySQL Instance"
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
    timeout     = "5m" # Adjust timeout as needed
    agent       = false

  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mysql-server",
      "sudo systemctl start mysqld",
      "sudo systemctl enable mysqld",
      "sudo mysql -e 'CREATE DATABASE wordpress;'",
      "sudo mysql -e \"CREATE USER 'wpuser'@'%' IDENTIFIED BY 'wppassword';\"",
      "sudo mysql -e \"GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%' WITH GRANT OPTION;\"",
      "sudo mysql -e 'FLUSH PRIVILEGES;'",
    ]
  }
}


# Create MySQL EC2 instance in the public subnet
resource "aws_instance" "wordpress_instance" {
  ami                    = data.aws_ami.aws_linux_2_latest.id # Replace with the appropriate MySQL AMI ID
  key_name               = "default-ec2-example"
  instance_type          = "t2.micro" # Choose instance type as needed
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

  tags = {
    Name = "woedpress Instance"
  }

  connection {
    type        = "ssh"
    host        = self.private_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }


  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                                                                                                                                                                                                         //install httpd
      "sudo service httpd start",                                                                                                                                                                                                                                                          //start
      "echo Welcome page - Virtual server ${self.public_dns} private ${self.private_dns} ${self.private_ip} ${aws_instance.mysql_instance.public_dns} ${aws_instance.mysql_instance.private_ip} private1: ${aws_instance.mysql_instance.private_dns}| sudo  tee /var/www/html/index.html", //copy
      #   "sudo yum update -y",
      #   "sudo yum install -y httpd",
      #   "sudo systemctl start httpd",
      #   "sudo systemctl enable httpd",
      #   "sudo amazon-linux-extras install -y php7.4",
      #   "sudo yum install -y php-mysqlnd",
      #   "sudo systemctl restart httpd",
      #   "sudo yum install -y mysql",
      #   "sudo systemctl restart httpd",
      #   "sudo yum install -y php-gd",
      #   "sudo systemctl restart httpd",
      #   "sudo yum install -y php-xml",
      #   "sudo systemctl restart httpd",
      #   "sudo wget https://wordpress.org/latest.tar.gz",
      #   "sudo tar -xzf latest.tar.gz -C /var/www/html/",
      #   "sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php",
      #   "sudo sed -i 's/database_name_here/wordpress/g' /var/www/html/wordpress/wp-config.php",
      #   "sudo sed -i 's/username_here/wpuser/g' /var/www/html/wordpress/wp-config.php",
      #   "sudo sed -i 's/password_here/wppassword/g' /var/www/html/wordpress/wp-config.php",
      #   "sudo sed -i 's/localhost/your_mysql_private_ip/g' /var/www/html/wordpress/wp-config.php",
      #   "sudo chown -R apache:apache /var/www/html/wordpress",
      #   "sudo systemctl restart httpd",
    ]
  }
}

