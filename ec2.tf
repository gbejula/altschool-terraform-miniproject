resource "aws_instance" "tera-1" {
  ami = var.ami
  instance_type = var.type
  security_groups = [aws_security_group.tera-sg.id]
  key_name = var.key_pair
  subnet_id = aws_subnet.tera-public-subnet1.id
  availability_zone = var.availability_zone["a"]

  connection {
    type = "ssh"
    host = "self.public.ip"
    user = "ubuntu"
    private_key = file("/root/terraform/miniproject.pem")
  }

    tags = {
      Name = "tera-1"
      source = "terraform"
    }
}

resource "aws_instance" "tera-2" {
  ami = var.ami
  instance_type = var.type
  key_name = var.key_pair
  security_groups = [aws_security_group.tera-sg.id]
  subnet_id = aws_subnet.tera-public-subnet2.id
  availability_zone = var.availability_zone["b"]

  connection {
    type = "ssh"
    host = "self.public_ip"
    user = "ubuntu"
    private_key = file("/root/terraform/miniproject.pem")
  }

  tags = {
    Name = "tera-2"
    source = "terraform"
  }
}

resource "aws_instance" "tera-3" {
  ami = var.ami
  instance_type = var.type
  security_groups = [aws_security_group.tera-sg.id]
  subnet_id = aws_subnet.tera-public-subnet1.id
  availability_zone = var.availability_zone["a"]

  connection {
    type = "ssh"
    host = "self.public_ip"
    user = "ubuntu"
    private_key = file("/root/terraform/miniproject.pem")
  }

  tags = {
    Name = "tera-3"
    source = "terraform"
  }
}

resource "local_file" "name" {
  filename = ("/root/terraform/miniproject.pem")
  content = <<EOT
  $(aws_instance.tera-1.public_ip)
  $(aws_instance.tera-2.public_ip)
  $(aws_instance.tera-1.public_ip)
  EOT
}