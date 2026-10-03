data "aws_network_interface" "public" {
  filter {
    name   = "attachment.instance-id"
    values = [var.public_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }
}

data "aws_network_interface" "private" {
  filter {
    name   = "attachment.instance-id"
    values = [var.private_instance_id]
  }

  filter {
    name   = "attachment.device-index"
    values = ["0"]
  }
}

resource "aws_security_group" "ssh" {
  name        = "${var.project_id}-ssh-sg"
  description = "Allow SSH and ICMP from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}

resource "aws_security_group" "public_http" {
  name        = "${var.project_id}-public-http-sg"
  description = "Allow HTTP and ICMP from allowed IP ranges"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}

resource "aws_security_group" "private_http" {
  name        = "${var.project_id}-private-http-sg"
  description = "Allow HTTP and ICMP from the public HTTP security group"
  vpc_id      = var.vpc_id

  tags = {
    Project = var.project_id
  }
}


resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id

  protocol    = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_blocks = var.allowed_ip_range

  description = "Allow SSH from allowed IP ranges"
}

resource "aws_security_group_rule" "ssh_icmp_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.ssh.id

  protocol    = "icmp"
  from_port   = -1
  to_port     = -1
  cidr_blocks = var.allowed_ip_range

  description = "Allow ICMP from allowed IP ranges"
}

resource "aws_security_group_rule" "public_http_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http.id

  protocol    = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_blocks = var.allowed_ip_range

  description = "Allow HTTP from allowed IP ranges"
}

resource "aws_security_group_rule" "public_http_icmp_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.public_http.id

  protocol    = "icmp"
  from_port   = -1
  to_port     = -1
  cidr_blocks = var.allowed_ip_range

  description = "Allow ICMP from allowed IP ranges"
}

resource "aws_security_group_rule" "private_http_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.private_http.id

  protocol  = "tcp"
  from_port = 8080
  to_port   = 8080

  source_security_group_id = aws_security_group.public_http.id

  description = "Allow HTTP from public HTTP security group"
}

resource "aws_security_group_rule" "private_http_icmp_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.private_http.id

  protocol  = "icmp"
  from_port = -1
  to_port   = -1

  source_security_group_id = aws_security_group.public_http.id

  description = "Allow ICMP from public HTTP security group"
}

resource "aws_network_interface_sg_attachment" "public_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.public.id
}

resource "aws_network_interface_sg_attachment" "public_http" {
  security_group_id    = aws_security_group.public_http.id
  network_interface_id = data.aws_network_interface.public.id
}

resource "aws_network_interface_sg_attachment" "private_ssh" {
  security_group_id    = aws_security_group.ssh.id
  network_interface_id = data.aws_network_interface.private.id
}

resource "aws_network_interface_sg_attachment" "private_http" {
  security_group_id    = aws_security_group.private_http.id
  network_interface_id = data.aws_network_interface.private.id
}
