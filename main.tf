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



provider "aws" {
          region = "ap-south-1"
}

resource "aws_s3_bucket" "resource1-s3" {
           bucket = "terraform-vegan"
}

resource "aws_instance" "resource2-ec2" {
           ami = var.ec2-ubuntu-ami
           instance_type = "t2.micro"
           tags = {
                    Name = "terraform-ec2"
           }
}