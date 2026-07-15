terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true


  endpoints {
    s3  = "http://localhost:4566"
    ec2 = "http://localhost:4566"

  }
}

resource "aws_s3_bucket" "mon_premier_bucket" {
  bucket = "mon-bucket-test-cv"
}
resource "aws_vpc" "mon_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-projet-cv"
  }
}

resource "aws_subnet" "mon_subnet" {
  vpc_id     = aws_vpc.mon_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet-projet-cv"
  }
}

resource "aws_security_group" "mon_sg" {
  name        = "aws_security_group.mon_sg-projet-cv"
  description = "Autorise HTTP et SSH"
  vpc_id      = aws_vpc.mon_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}