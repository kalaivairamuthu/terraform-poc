// An Azure resource group

resource "aws_vpc" "vpc" {
  cidr_block = var.VPC_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_security_group" "ingress-all" {
  name = "allow-all-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  // Terraform removes the default rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet1" {
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 3, 1)
  vpc_id = aws_vpc.vpc.id
  availability_zone = var.AvailabilityZone
}

resource "aws_instance" "default" {
  ami                         = var.ImageId
  associate_public_ip_address = true
  instance_type               = var.InstanceType
  key_name                    = var.KeyName
  vpc_security_group_ids      = [aws_security_group.ingress-all.id]
  subnet_id                   = aws_subnet.subnet1.id
  user_data                   = data.template_file.user_data.rendered
  tags = {
    Name = "Aws_Centos_Hardened"
  }

  connection {
    user = "centos"
    password = "password"
    //private_key = var.key_name
    agent = false
    host = aws_instance.default.public_ip
  }

  provisioner "file" {
    source = "hardening.sh"
    destination = "/tmp/hardening.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/hardening.sh",
      "/tmp/hardening.sh",
    ]
  }

}


data "template_file" "user_data" {
  template = templatefile("user_data.tmpl", {
    hostname = "centos"
  }
  )
}

resource "aws_ami_from_instance" "default" {
  name               = "centos-ami"
  source_instance_id = "${element(aws_instance.default.*.id, 0)}"
}


// A variable for extracting the external ip of the instance
output "ip" {
  value = aws_instance.default.public_ip
}
