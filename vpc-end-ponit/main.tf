provider "aws" {
  region = "us-east-1"  # Change as needed
}

# Define a VPC
resource "aws_vpc" "example" {
    enable_dns_hostnames = true
  cidr_block = "10.0.0.0/16"
}

# Define a subnet
resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  availability_zone = "us-east-1b"
  cidr_block = "10.0.1.0/24"
}

# Define a security group
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   ingress {
#     from_port   = 25      # SMTP port
#     to_port     = 25
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Adjust as necessary
#   }
  ingress = [
    for port in [22,25, 587,] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      ipv6_cidr_blocks = ["::/0"]
      self             = false
      prefix_list_ids  = []
      security_groups  = []
      cidr_blocks      = ["0.0.0.0/0"]
    }
  ]
}

# Define an EC2 instance
resource "aws_instance" "smtp" {
  ami           = "ami-066784287e358dad1"  # Replace with a suitable AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example.id
  key_name = "vsv"
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.example.id ]

  tags = {
    Name = "SMTP-Server"
  }
}
#  private ec2
resource "aws_instance" "smtp1" {
  ami           = "ami-066784287e358dad1"  # Replace with a suitable AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.name.id
  key_name = "vsv"
#   associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.instance-profile.name

  vpc_security_group_ids = [ aws_security_group.example.id ]

  tags = {
    Name = "SMTP-Server-prvt"
  }
}
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.example.id
}

# Optional: Define a route table if needed
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id # Ensure this matches your internet gateway
  }
}
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.example.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1c"
    tags = {
      Name = "prvt-sub-terraforrm"
    }
  
}
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.example.id
}
resource "aws_route_table_association" "name" {
  subnet_id = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}
resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}
# Create a VPC endpoint for SES using AWS PrivateLink
resource "aws_vpc_endpoint" "ses" {
  vpc_id            = aws_vpc.example.id
  service_name       = "com.amazonaws.us-east-1.email-smtp"  # Adjust region as necessary
  vpc_endpoint_type  = "Interface"
  security_group_ids = [aws_security_group.example.id]
  subnet_ids         = [aws_subnet.example.id,aws_subnet.name.id]

  private_dns_enabled = true
  tags = {
    Name = "smtp-endponit"
  }
}


resource "aws_iam_role" "iam-role" {
  name               = "Jumphost-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam-policy" {
  role = aws_iam_role.iam-role.name
  # Just for testing purpose, don't try to give administrator access in production
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "instance-profile" {
  name = "naresh-veera-profile"
  role = aws_iam_role.iam-role.name
}