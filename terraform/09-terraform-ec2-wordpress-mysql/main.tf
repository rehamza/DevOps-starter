# US East (N. Virginia)
# us-east-1
# Amazon Machine Image   = ami-0230bd60aa48260c6
# Instance type =  t2.micro
# VPC = vpc-08199515cc12c93b8

provider "aws" {
  region = "us-east-1"
  //version = "~> 2.46" (No longer necessary)
}



// update code add dynamic VPC
resource "aws_default_vpc" "default" {

}

// http server -> SG
// SG --> 80 TCP , 22 TCP , for anywhere CDIR ["0.0.0.0/0"] = access from anywhere on this address

resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg_wordpress_proj"
  # vpc_id = "vpc-08199515cc12c93b8"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming traffic on port 80"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH traffic"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    name = "http-server-sg"
  }
}

resource "aws_instance" "http_server" {
  # ami                    = "ami-0230bd60aa48260c6"                #important mandatory
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "default-ec2-example"                  #important mandatory
  instance_type          = "t2.micro"                             #important mandatory
  vpc_security_group_ids = [aws_security_group.http_server_sg.id] #important mandatory
  # subnet_id              = "subnet-09d552f9b16664633"             #important mandatory
  subnet_id = data.aws_subnets.default_subnets.ids[0]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install httpd -y",                                                                  //install httpd
      "sudo service httpd start",                                                                   //start
      "echo Welcome page - Virtual server ${self.public_dns} | sudo  tee /var/www/html/index.html", //copy
      # Install PHP and other dependencies required by WordPress
      "sudo amazon-linux-extras install -y php7.4",
      "sudo yum install php php-mysqlnd -y",
      # Download and extract WordPress
      "sudo wget https://wordpress.org/latest.tar.gz -P /var/www/html/",
      "sudo tar -zxvf /var/www/html/latest.tar.gz -C /var/www/html/",
      "sudo mv /var/www/html/wordpress/* /var/www/html/",
      "sudo rm -rf /var/www/html/wordpress",
      "sudo chown -R apache:apache /var/www/html/",
      "sudo chmod -R 755 /var/www/html/",

      # Configure WordPress wp-config.php
      "sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php",
      "sudo sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php",
      "sudo sed -i 's/username_here/wordpress/' /var/www/html/wp-config.php",
      "sudo sed -i 's/password_here/your_password/' /var/www/html/wp-config.php",

      # Install MySQL client and server
      "sudo rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7.rpm",
      "sudo yum install -y mysql-community-server",

      # Start MySQL service
      "sudo service mysqld start",

      # Wait for the MySQL service to start
      "sudo systemctl status mysqld",
      "while [[ $? -ne 0 ]]; do sleep 5; sudo systemctl status mysqld; done",

      # Secure MySQL installation
      "sudo mysql_secure_installation",

      # Create MySQL database and user for WordPress
      "sudo mysql -e 'CREATE DATABASE wordpress;'",
      "sudo mysql -e 'CREATE USER \"wordpress\"@\"localhost\" IDENTIFIED BY \"your_password\";'",
      "sudo mysql -e 'GRANT ALL PRIVILEGES ON wordpress.* TO \"wordpress\"@\"localhost\";'",
      "sudo mysql -e 'FLUSH PRIVILEGES;'",

    ]

  }

}