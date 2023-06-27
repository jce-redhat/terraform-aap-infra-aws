output "aap_build_id" {
  value = random_id.aap_id.hex
}

output "bastion_public_fqdn" {
  description = "Public FQDN of the AAP bastion"
  value       = aws_instance.bastion.public_dns
}

output "controller_public_fqdns" {
  description = "Public FQDN of the AAP controllers"
  value       = aws_route53_record.controller.*.name
}

output "hub_public_fqdns" {
  description = "Public FQDN of the AAP hubs"
  value       = aws_route53_record.hub.*.name
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
