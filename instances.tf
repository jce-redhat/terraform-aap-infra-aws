data "aws_ami" "rhel_9" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-9.1*Hourly*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "bastion" {
  instance_type               = var.bastion_instance_type
  ami                         = var.bastion_image_id != "" ? var.bastion_image_id : data.aws_ami.rhel_9.id
  key_name                    = var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name      = var.bastion_instance_name
    node_type = "bastion"
    build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_instance" "controller" {
  count = 1

  instance_type               = var.controller_instance_type
  ami                         = var.controller_image_id != "" ? var.controller_image_id : data.aws_ami.rhel_9.id
  key_name                    = var.controller_key_name != "" ? var.controller_key_name : var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.controller.id,
    aws_security_group.public_subnet.id
  ]

  tags = {
    Name      = "${var.controller_instance_name}${count.index}"
    node_type = "controller"
    build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_instance" "hub" {
  count = 1

  instance_type               = var.hub_instance_type
  ami                         = var.hub_image_id != "" ? var.hub_image_id : data.aws_ami.rhel_9.id
  key_name                    = var.hub_key_name != "" ? var.hub_key_name : var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  vpc_security_group_ids = [
    aws_security_group.hub.id,
    aws_security_group.public_subnet.id
  ]

  tags = {
    Name      = "${var.hub_instance_name}${count.index}"
    node_type = "hub"
    build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_instance" "database" {
  count = 0

  instance_type               = var.database_instance_type
  ami                         = var.database_image_id != "" ? var.database_image_id : data.aws_ami.rhel_9.id
  key_name                    = var.database_key_name != "" ? var.database_key_name : var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = false
  vpc_security_group_ids = [
    aws_security_group.public_subnet.id
  ]

  tags = {
    Name      = "${var.database_instance_name}${count.index}"
    node_type = "database"
    build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_instance" "execution" {
  count = 0

  instance_type               = var.execution_instance_type
  ami                         = var.execution_image_id != "" ? var.execution_image_id : data.aws_ami.rhel_9.id
  key_name                    = var.execution_key_name != "" ? var.execution_key_name : var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = false
  vpc_security_group_ids = [
    aws_security_group.public_subnet.id
  ]

  tags = {
    Name      = "${var.execution_instance_name}${count.index}"
    node_type = "execution_node"
    build_id  = "${random_id.aap_id.hex}"
  }
}
