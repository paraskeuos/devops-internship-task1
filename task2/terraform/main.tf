provider "aws" {}

resource "aws_default_vpc" "vpc" {}

resource "aws_instance" "jenkins_server" {
    instance_type = "t2.micro"
    ami = "ami-0caef02b518350c8b"
    key_name = "tf_ubuntu"
    vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
}

resource "aws_security_group" "allow_ssh" {

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }

  /*
  ingress {
    from_port = 5000
    to_port   = 10000
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  */
  
  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0"]
  }
}

