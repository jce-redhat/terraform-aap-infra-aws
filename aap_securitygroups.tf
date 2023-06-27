resource "aws_security_group" "bastion" {
  name        = "aap-bastion-${random_id.aap_id.hex}"
  description = "AAP bastion ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "SSH"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "controller" {
  name        = "aap-controller-${random_id.aap_id.hex}"
  description = "AAP controller ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from bastion"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_instance.bastion.private_ip}/32",
      "${aws_instance.bastion.public_ip}/32",
    ]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "hub" {
  name        = "aap-hub-${random_id.aap_id.hex}"
  description = "AAP hub ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from bastion"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_instance.bastion.private_ip}/32",
      "${aws_instance.bastion.public_ip}/32",
    ]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "public_subnet" {
  name        = "aap-public-subnet-${random_id.aap_id.hex}"
  description = "Rules for all instances on the AAP public subnet"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = flatten([
      local.aap_public_subnet_cidr,
      var.disconnected ? [local.aap_private_subnet_cidr] : []
    ])
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      local.aap_public_subnet_cidr,
      local.aap_private_subnet_cidr
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "private_subnet" {
  count = var.disconnected ? 1 : 0

  name        = "aap-private-subnet-${random_id.aap_id.hex}"
  description = "Rules for all instances on the AAP private subnet"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      local.aap_public_subnet_cidr,
      local.aap_private_subnet_cidr,
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      local.aap_public_subnet_cidr,
      local.aap_private_subnet_cidr,
      local.rhui_cidr[var.aap_aws_region]
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "edacontroller" {
  name        = "aap-edacontroller-${random_id.aap_id.hex}"
  description = "AAP EDA controller ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH from bastion"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [
      "${aws_instance.bastion.private_ip}/32",
      "${aws_instance.bastion.public_ip}/32",
    ]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "db_ingress_controller" {
  count = var.controller_count

  description       = "Database ingress from AAP controller EIPs"
  type              = "ingress"
  security_group_id = aws_security_group.controller.id
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks = [
    "${aws_eip.controller[count.index].public_ip}/32"
  ]
}

resource "aws_security_group_rule" "db_ingress_hub" {
  count = var.hub_count

  description       = "Database ingress from AAP hub EIPs"
  type              = "ingress"
  security_group_id = aws_security_group.controller.id
  from_port         = "5432"
  to_port           = "5432"
  protocol          = "tcp"
  cidr_blocks = [
    "${aws_eip.hub[count.index].public_ip}/32"
  ]
}
