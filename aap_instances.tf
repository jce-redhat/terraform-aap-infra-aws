locals {
  rhel_ami = var.use_rhel9 ? data.aws_ami.rhel9 : data.aws_ami.rhel8
}

resource "aws_instance" "bastion" {
  instance_type               = var.bastion_instance_type
  ami                         = var.bastion_image_id != "" ? var.bastion_image_id : local.rhel_ami.id
  key_name                    = var.bastion_key_name
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name          = var.bastion_instance_name
    aap_node_type = "bastion"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "ansible_host" "bastion" {
  name   = aws_instance.bastion.public_dns
  groups = ["bastion"]
  variables = {
    ansible_user = "ec2-user"
  }
}

resource "aws_instance" "controller" {
  count = var.controller_count

  instance_type               = var.controller_instance_type
  ami                         = var.controller_image_id != "" ? var.controller_image_id : local.rhel_ami.id
  key_name                    = var.controller_key_name != "" ? var.controller_key_name : var.bastion_key_name
  subnet_id                   = var.disconnected ? aws_subnet.private[0].id : aws_subnet.public.id
  associate_public_ip_address = var.disconnected ? false : true
  vpc_security_group_ids = flatten([
    aws_security_group.controller.id,
    aws_security_group.public_subnet.id,
    var.disconnected ? [aws_security_group.private_subnet[0].id] : []
  ])
  root_block_device {
    volume_size = var.controller_disk_size
  }

  tags = {
    Name          = "${var.controller_instance_name}${count.index}"
    aap_node_type = "controller"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_eip" "controller" {
  count = var.controller_count

  instance = aws_instance.controller[count.index].id
  domain   = "vpc"
}

resource "ansible_host" "controller" {
  count = var.controller_count

  name   = aws_route53_record.controller[count.index].name
  groups = ["controller"]
  variables = {
    ansible_user = "ec2-user"
  }
}

resource "aws_instance" "hub" {
  count = var.hub_count

  instance_type               = var.hub_instance_type
  ami                         = var.hub_image_id != "" ? var.hub_image_id : local.rhel_ami.id
  key_name                    = var.hub_key_name != "" ? var.hub_key_name : var.bastion_key_name
  subnet_id                   = var.disconnected ? aws_subnet.private[0].id : aws_subnet.public.id
  associate_public_ip_address = var.disconnected ? false : true
  vpc_security_group_ids = flatten([
    aws_security_group.hub.id,
    aws_security_group.public_subnet.id,
    var.disconnected ? [aws_security_group.private_subnet[0].id] : []
  ])
  root_block_device {
    volume_size = var.hub_disk_size
  }

  tags = {
    Name          = "${var.hub_instance_name}${count.index}"
    aap_node_type = "hub"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_eip" "hub" {
  count = var.hub_count

  instance = aws_instance.hub[count.index].id
  domain   = "vpc"
}

resource "ansible_host" "hub" {
  count = var.hub_count

  name   = aws_route53_record.hub[count.index].name
  groups = ["hub"]
  variables = {
    ansible_user = "ec2-user"
  }
}

resource "aws_instance" "database" {
  count = var.database_count

  instance_type               = var.database_instance_type
  ami                         = var.database_image_id != "" ? var.database_image_id : local.rhel_ami.id
  key_name                    = var.database_key_name != "" ? var.database_key_name : var.bastion_key_name
  subnet_id                   = var.disconnected ? aws_subnet.private[0].id : aws_subnet.public.id
  associate_public_ip_address = false
  vpc_security_group_ids = flatten([
    aws_security_group.public_subnet.id,
    var.disconnected ? [aws_security_group.private_subnet[0].id] : []
  ])
  root_block_device {
    volume_size = var.database_disk_size
  }

  tags = {
    Name          = "${var.database_instance_name}${count.index}"
    aap_node_type = "database"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "ansible_host" "database" {
  count = var.database_count

  name   = aws_instance.database[count.index].private_dns
  groups = ["database"]
  variables = {
    ansible_user = "ec2-user"
  }
}

resource "aws_instance" "execution" {
  count = var.execution_count

  instance_type               = var.execution_instance_type
  ami                         = var.execution_image_id != "" ? var.execution_image_id : local.rhel_ami.id
  key_name                    = var.execution_key_name != "" ? var.execution_key_name : var.bastion_key_name
  subnet_id                   = var.disconnected ? aws_subnet.private[0].id : aws_subnet.public.id
  associate_public_ip_address = false
  vpc_security_group_ids = flatten([
    aws_security_group.public_subnet.id,
    var.disconnected ? [aws_security_group.private_subnet[0].id] : []
  ])
  root_block_device {
    volume_size = var.execution_disk_size
  }

  tags = {
    Name          = "${var.execution_instance_name}${count.index}"
    aap_node_type = "execution"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "ansible_host" "execution" {
  count = var.execution_count

  name   = aws_instance.execution[count.index].public_dns
  groups = ["execution"]
  variables = {
    ansible_user = "ec2-user"
  }
}

resource "aws_instance" "edacontroller" {
  count = var.edacontroller_count

  instance_type               = var.edacontroller_instance_type
  ami                         = var.edacontroller_image_id != "" ? var.edacontroller_image_id : local.rhel_ami.id
  key_name                    = var.edacontroller_key_name != "" ? var.edacontroller_key_name : var.bastion_key_name
  subnet_id                   = var.disconnected ? aws_subnet.private[0].id : aws_subnet.public.id
  associate_public_ip_address = var.disconnected ? false : true
  vpc_security_group_ids = flatten([
    aws_security_group.edacontroller.id,
    aws_security_group.public_subnet.id,
    var.disconnected ? [aws_security_group.private_subnet[0].id] : []
  ])
  root_block_device {
    volume_size = var.edacontroller_disk_size
  }

  tags = {
    Name          = "${var.edacontroller_instance_name}${count.index}"
    aap_node_type = "edacontroller"
    aap_build_id  = "${random_id.aap_id.hex}"
  }
}

resource "aws_eip" "edacontroller" {
  count = var.edacontroller_count

  instance = aws_instance.edacontroller[count.index].id
  domain   = "vpc"
}

resource "ansible_host" "edacontroller" {
  count = var.edacontroller_count

  name   = aws_route53_record.edacontroller[count.index].name
  groups = ["edacontroller"]
  variables = {
    ansible_user = "ec2-user"
  }
}
