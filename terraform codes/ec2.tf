resource "aws_instance" "public" {
  ami                    = "ami-0fc5d935ebf8bc3bc"  # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t2.small"
  subnet_id              = aws_subnet.public1.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  key_name               = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "public-instance"
  }
}

resource "aws_instance" "app" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.small"
  subnet_id              = aws_subnet.private1.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "app-instance"
  }
}

resource "aws_instance" "jenkins" {
  ami                    = "ami-0fc5d935ebf8bc3bc"
  instance_type          = "t2.small"
  subnet_id              = aws_subnet.private2.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  tags = {
    Name = "jenkins-instance"
  }
}
