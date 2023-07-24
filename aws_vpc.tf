# this is only required once to pass the credential then the terraform
#  make the  connection and let you do anything in AWS env

#provider "aws" {
#  region = "us-east-1"
#  access_key = "AKIA5DFWSGKGFK2F3HLV"
#  secret_key = "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"
#}


#commenting this code to stop the VPC created by terraform
# Create a VPC
#resource "aws_vpc" "first_vpc" {
#  cidr_block = "10.0.0.0/16"
#  tags={
#	Name ="Production_vpc"
#}
#}

#resource "aws_subnet" "subnet-1" {
#  vpc_id     = aws_vpc.first_vpc.id
#  cidr_block = "10.0.1.0/24"
#
#  tags = {
#    Name = "subnet-1"
#  }
#}
