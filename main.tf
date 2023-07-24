provider "aws" {
  region = "us-east-1"
  access_key = "AKIA5DFWSGKGFK2F3HLV"
  secret_key = "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"
}

#resource "aws_instance" "terraform_vm" {
#  ami           = "ami-06ca3ca175f37dd66"
#  instance_type = "t2.micro"
#  tags={
#      Name = "Ubuntu_terra" #this line is use to name the server on AWS, if you comment out this line the intanse will again go to blank name
#}
#}
