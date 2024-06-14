provider "aws" {
  region = "ap-south-1"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Get the default subnets in the default VPC
data "aws_subnets" "available" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Get an available availability zone
data "aws_availability_zones" "available" {}

# Create a DB subnet group
resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = data.aws_subnets.available.ids

  tags = {
    Name = "MyDBSubnetGroup"
  }
}

# Create the RDS instance
resource "aws_db_instance" "default" {
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0.35"
  instance_class          = "db.t3.micro"
  username                = "admin"
  password                = var.db-password
  db_subnet_group_name    = aws_db_subnet_group.default.name
  availability_zone       = data.aws_availability_zones.available.names[0]
  skip_final_snapshot     = true
  publicly_accessible     = true
  backup_retention_period = 1
  storage_type            = "gp2"
  vpc_security_group_ids  = [aws_security_group.r5_allow_ssh.id]

  tags = {
    Name = "MyRDSInstance"
  }
}

resource "aws_security_group" "r5_allow_ssh" {
  name        = "allow_mysql"
  description = "Allow mysql inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "allow_mysql"
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "db_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = aws_db_instance.default.endpoint
}

output "db_username" {
  description = "The username for the RDS instance"
  value       = aws_db_instance.default.username
}

