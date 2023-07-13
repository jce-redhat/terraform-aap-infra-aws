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

# for each public node type (controller, hub, edacontroller), if there is
# only a single node, the FQDN will point to the node's EIP.  if there is
# more than one node, the FQDN will point to the load balancer fronting
# the nodes.
resource "aws_route53_record" "controller" {
  count = var.controller_count == 1 ? 1 : 0

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "controller.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.controller[count.index].public_ip]
}

resource "aws_route53_record" "controller_lb" {
  count = var.controller_count > 1 ? 1 : 0

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "controller.${var.aap_dns_zone}"
  type    = "A"

  alias {
    name                   = aws_lb.aap_frontend.dns_name
    zone_id                = aws_lb.aap_frontend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "hub" {
  count = var.hub_count == 1 ? 1 : 0

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "hub.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.hub[count.index].public_ip]
}

resource "aws_route53_record" "edacontroller" {
  count = var.edacontroller_count == 1 ? 1 : 0

  zone_id = data.aws_route53_zone.sandbox.zone_id
  name    = "edacontroller.${var.aap_dns_zone}"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.edacontroller[count.index].public_ip]
}
