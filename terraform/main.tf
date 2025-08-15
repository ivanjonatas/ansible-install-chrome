provider "aws" {
  region = "us-east-1" # Região free-tier friendly
}

resource "aws_vpc" "default" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "youtube-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "youtube-public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "youtube-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "youtube-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all_traffic"
  description = "Security Group that allows all inbound/outbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-all"
  }
}

resource "aws_instance" "youtube_instance" {
  ami                    = "ami-020cba7c55df1f615" # Ubuntu Server 22.04 LTS (us-east-1)
  instance_type          = "t2.micro"
  key_name               = "youtube-teste"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt upgrade -y
              wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
              apt-get install -y ./google-chrome-stable_current_amd64.deb
              apt install -y python3-pip
              pip3 install selenium
              pip3 install webdriver-manager
              EOF

  tags = {
    Name = "youtube-chrome-instance"
  }
}
