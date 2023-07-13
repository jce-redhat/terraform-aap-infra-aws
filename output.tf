output "aap_build_id" {
  value = random_id.aap_id.hex
}

output "bastion_public_fqdn" {
  description = "Public FQDN of the AAP bastion"
  value       = aws_route53_record.bastion.name
}

output "controller_public_fqdns" {
  description = "Public FQDN of the AAP controllers"
  value       = aws_route53_record.controller.*.name
}
output "controller_private_fqdns" {
  description = "Private FQDN of the AAP controllers"
  value       = aws_instance.controller.*.private_dns
}

output "hub_public_fqdns" {
  description = "Public FQDN of the AAP hubs"
  value       = aws_route53_record.hub.*.name
}
output "hub_private_fqdns" {
  description = "Private FQDN of the AAP hubs"
  value       = aws_instance.hub.*.private_dns
}

output "database_private_fqdns" {
  description = "Private FQDN of the AAP databases"
  value       = aws_instance.database.*.private_dns
}

output "execution_public_fqdns" {
  description = "Public FQDN of the AAP execution nodes"
  value       = aws_instance.execution.*.public_dns
}

output "edacontroller_public_fqdns" {
  description = "Public FQDN of the AAP EDA controllers"
  value       = aws_route53_record.edacontroller.*.name
}
output "edacontroller_private_fqdns" {
  description = "Private FQDN of the AAP EDA controllers"
  value       = aws_instance.edacontroller.*.private_dns
}

output "load_balancer_dns_name" {
  description = "DNS name of the front-end load balancer"
  value       = aws_lb.aap_frontend.dns_name
}
