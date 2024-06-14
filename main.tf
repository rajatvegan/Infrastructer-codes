/*
provider "docker" {}

resource "local_file" "resource1-file" {
                        filename = "/home/rajat/terraform/file.txt"
                        content  = "hello 1 2"
}

resource "docker_image" "r2_unity_image" {
                        name = "rajatvegan/unity-app:latest"
                        keep_locally = false
}

resource "docker_container" "r3-unity_contnr" {
                        name  = "my-unity-app-contnr"
                        image = docker_image.r2_unity_image.name
                ports {
                        internal = 800
                        external = 80
                }
}
*/


provider "aws" {
          region = "ap-south-1"
}

resource "aws_s3_bucket" "resource1-s3" {
           bucket = "terraform-vegan"
}

resource "aws_instance" "resource2-ec2" {
           ami = var.ec2-ubuntu-ami
           instance_type = "t2.micro"
           key_name = aws_key_pair.resource3-key-pair.key_name
           security_groups = ["${aws_security_group.r5_allow_ssh.name}"]
           tags = {
                    Name = "terraform-ec2"
           }
}

resource "aws_key_pair" "resource3-key-pair" {
           key_name = "gcp-vm-key-pair"
           public_key = file("/home/rajat/.ssh/id_ed25519.pub")
}

resource "aws_default_vpc" "r4-vpc" {}

resource "aws_security_group" "r5_allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.r4-vpc.id
  tags = {
    Name = "allow_ssh"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  value = aws_instance.resource2-ec2.public_ip
}

