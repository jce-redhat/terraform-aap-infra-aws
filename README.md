# ARCHIVED

This repository has been archived in favor of the [terraform-aap-sandbox](https://github.com/jce-redhat/terraform-aap-sandbox) repo.

# terraform-aap-infra-aws - Build AAP infrastructure nodes on AWS with Terraform

Terraform configuration for building Ansible Automation Platform (AAP) infrastructure
nodes - automation controller, private automation hub, etc. - in an AWS VPC.  This
repo can be used as a stand-alone tool, but is designed to be used with the Ansible
[cloud.terraform](https://github.com/ansible-collections/cloud.terraform) collection.

## Using the repo manually

1. Create a config.s3.tfbackend file from the example provided.  Modify the bucket, key, and region as appropriate.  The bucket used to store the terraform state must already exist.
```
cp config.s3.tfbackend.example config.s3.tfbackend
vim config.s3.tfbackend
```
2. Initialize terraform using the new tfbackend file.
```
terraform init -backend-config=config.s3.tfbackend
```
3. Create a terraform.tfvars file from the example provided.  This file is used to override variable defaults found in the variables.tf file.  At a minimum, the value of the `bastion_key_name` variable should be changed to an SSH key that exists in the AWS region being used.  This key is used to log in to the bastion and other instances created.
```
cp terraform.tfvars.example terraform.tfvars
vim terraform.tfvars
```
4. Run terraform to create the AAP infrastructure VPC, networking, and server instances.
```
terraform apply
```

