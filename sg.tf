resource "aws_security_group" "public_sg" {
  name   = "public-tier-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "app_sg" {
  name   = "app-tier-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "db_sg" {
  name   = "data-tier-sg"
  vpc_id = aws_vpc.main.id
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-host-sg"
  vpc_id = aws_vpc.main.id
}


resource "aws_security_group_rule" "public_to_app" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.app_sg.id
  source_security_group_id = aws_security_group.public_sg.id
}

resource "aws_security_group_rule" "app_to_db" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "public_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.public_sg.id
  source_security_group_id = aws_security_group.app_sg.id
}

resource "aws_security_group_rule" "db_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.db_sg.id
}

resource "aws_security_group_rule" "bastion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["192.168.1.189/32"]
  security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_instance" "bastion_host" {
  ami                    = "ami-07ff62358b87c7116"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
}

resource "aws_network_acl" "app_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = var.app_subnet_ids

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 443
    to_port    = 443
  }

  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "app-tier-nacl"
  }
}

resource "aws_network_acl" "db_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = var.db_subnet_ids

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 5432
    to_port    = 5432
  }

  egress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
}
