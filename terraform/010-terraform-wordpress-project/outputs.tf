output "aws_security_group_wordpress_details" {
  value = aws_security_group.wordpress_sg
}

output "aws_security_group_mysql_sq_details" {
  value = aws_security_group.mysql_sg
}

output "wordpress_instance_public_dns" {
  value = aws_instance.wordpress_instance.public_dns
}

output "mysql_instance_public_dns" {
  value = aws_instance.mysql_instance.public_dns
}
output "mysql_instance_private_dns" {
  value = aws_instance.mysql_instance.private_dns
}

output "mysql_instance_private_ip" {
  value = aws_instance.mysql_instance.private_ip
}