output "aap_build_id" {
  value = random_id.aap_id.hex
}

output "bastion_public_fqdn" {
  description = "Public FQDN of the AAP bastion"
  value       = aws_instance.bastion.public_dns
}
output "bastion_private_fqdn" {
  description = "Private FQDN of the AAP bastion"
  value       = aws_instance.bastion.private_dns
}

output "controller_public_fqdns" {
  description = "Public FQDN of the AAP controllers"
  value       = aws_instance.controller.*.public_dns
}
output "controller_private_fqdns" {
  description = "Private FQDN of the AAP controllers"
  value       = aws_instance.controller.*.private_dns
}

output "hub_public_fqdns" {
  description = "Public FQDN of the AAP hubs"
  value       = aws_instance.hub.*.public_dns
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
output "execution_private_fqdns" {
  description = "Private FQDN of the AAP execution nodes"
  value       = aws_instance.execution.*.private_dns
}
