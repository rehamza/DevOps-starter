# Title: Deploy WordPress Website on EC2 inside a VPC ( ETA: 3 Days )
## Department: AWS-Cloud
## Area: Networking, Infrastructure, DevOps
## Experience: Beginner
Problem Statement: We are building an e-commerce website on
WordPress and we need to host the WordPress application on the AWS-
EC2 instance. The application is ready but we first need to set up a test
environment that can serve as a proof of concept to the infrastructure team
before the actual WordPress is deployed. We need you to help us set up
the infrastructure with a sample WordPress website on the ec2 instance.
The CTO has provided some better context into what they think will work.
According to the email he sent, “You need to launch an EC2 web server
and database server to host a sample WordPress site and access it by
different users.” Once we confirm and verify that it is working correctly, we
will set up the same structure using Infrastructure as code and deploy the
real WordPress site into it.
Description:
● Create a Vpc and in that VPC, Launch 2 subnets in 2 different AZ (1
private subnet for database and 1 public subnet for the web)
● Next is to setup/install MySQL DB on EC2 in a private subnet (use
Amazon Linux 2 image)
● Setup/install WordPress on the EC2 created in the public subnet and
connect it to the above DB (use Amazon Linux 2 image)
● After doing all these, you should visit the EC2 IP and should be able to see a
WordPress website landing page

# Architecture Diagram:

Prerequisites:
● Understand the concept of VPC, Subnets, Networking, SSH, EC2
● You must have an idea for a WordPress website.
● You have knowledge of MySQL i-e how to install MySQL server and MySQL client.

## Hints:
1. Launch 2 EC2 instances. One for WordPress in the public subnet and another one for
the database in a private subnet
2. Choose AMI for the EC2 like Ubuntu or Linux up to you.
3. When choosing instance type, you can search for instances that already have a
WordPress site preinstalled (google this and research). T2 micro instances in the free
tier should be sufficient for a standard WordPress installation with little traffic.
4. AWS recommends that we create a new security group for this instance, which we will
do. Add appropriate inbound rules so that you can access the instance usually port 22 (
ssh ), 443 (HTTPS ), HTTP (80)
5. Launch the instance. Create a new key pair for the EC2 instance and download it to ssh
into the instance.
6. ssh into the instance and install the WordPress.
7. For the database EC@ instance, make sure it&#39;s created just like the steps above but
inside a private subnet. Also, create a Security group for the instance but you should not
allow all ports to the security group for the database instance. Just open the inbound
SQL port (3306) to the security group of the WordPress Instance. (Think about this well)

8. Once this is set up, you clearly cannot ssh into the database ec2 because it’s in a private
subnet. You should connect to the database server from the WordPress server since it&#39;s
in a public subnet.