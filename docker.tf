resource "aws_instance" "ec2_instance" {
  ami                    = "ami-09c813fb71547fc4f" # This is our devops-practice AMI ID
  vpc_security_group_ids = [aws_security_group.security_group.id]
  subnet_id = "subnet-0034958e99b0438ae"
  instance_type          = "t3.micro"

  root_block_device {
    volume_size = 50  # Set root volume size to 50GB
    volume_type = "gp3"  # Use gp3 for better performance (optional)
  }

  user_data = file("docker.sh")
  tags = {
    Name    = "docker"
  }
}

resource "aws_security_group" "security_group" {
  name        = "allow_all"
  description = "Allow all inbound traffic and all outbound traffic"
  vpc_id = "vpc-0cc15faba58e5f7f1"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

output "docker_ip" {
  value       = aws_instance.ec2_instance.public_ip
}