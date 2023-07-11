data "aws_route53_zone" "sandbox" {
  name = var.aap_dns_zone
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "bastion.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.bastion.public_ip]
}

resource "aws_route53_record" "controller" {
  count = var.controller_count

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "controller${count.index}.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.controller[count.index].public_ip]
}

resource "aws_route53_record" "hub" {
  count = var.hub_count

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "hub${count.index}.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.hub[count.index].public_ip]
}

resource "aws_route53_record" "edacontroller" {
  count = var.edacontroller_count

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "edacontroller${count.index}.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.edacontroller[count.index].public_ip]
}
