terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
}

provider "aws" {
  # Configuration options
}

data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}


resource "aws_instance" "Docker-Server" {
  ami ="ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  key_name = "XXXXXXX"
  vpc_security_group_ids = [aws_security_group.docker-sec-group.id]
  user_data = "${file("userdata.sh")}"
  tags = {
    Name = "Docker-Server"
  }
}

resource "aws_security_group" "docker-sec-group" {
  name = "docker-sec-grp"
  tags = {
    Name = "DOCKER_SEC_GROUP"
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

   ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

  egress {
    from_port =0
    protocol = "-1"
    to_port =0
    cidr_blocks = ["0.0.0.0/0"]
  }
}