#1. Create VPC

resource "aws_vpc" "production" {
  cidr_block = "10.0.0.0/16"
  tags ={
   Name = "production"
  }
}

#2. Create Internet Gateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.production.id

  tags = {
    Name = "gateway1"
  }
}


#3. Create Custom Route

resource "aws_route_table" "prod_route" {
  vpc_id = aws_vpc.production.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
   gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "prod_route"
  }
}

#4. Create a Subnet

resource "aws_subnet" "subnet1" {
  vpc_id     = aws_vpc.production.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Subnet1"
  }
}

#5. Associate subnet with Route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.prod_route.id
}

#6. Create Security Group to allow port 22,443,80

resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.production.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
#    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

#7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "net" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

#8. Assign an Elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.net.id
  associate_with_private_ip = "10.0.1.50"
  depends_on		    = [aws_internet_gateway.gateway]
}


#9. Create an Ubuntu server and install/enable webserver

resource "aws_instance" "web_server" {
	ami = "ami-053b0d53c279acc90"
	instance_type = "t2.micro"
	availability_zone = "us-east-1a"
	key_name = "Linux-key-dem"

network_interface {
	device_index =0
	network_interface_id = aws_network_interface.net.id
}
	user_data = <<-EOF
			#!/bin/bash
			sudo apt update -y
			sudo apt install apache2 -y
			sudo systemct1 start apache2
			sudo bash -c 'echo Hi people, how are you > /var/www/html/index.html'
			EOF
	tags = {
		Name = "web-server"
}
}
