variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "bastion_instance_name" {
  type    = string
  default = "bastion"
}
variable "bastion_instance_type" {
  type    = string
  default = "t3.micro"
}
variable "bastion_image_id" {
  type    = string
  default = ""
}
variable "bastion_key_name" {
  type    = string
  default = ""
}

variable "controller_instance_name" {
  type    = string
  default = "controller"
}
variable "controller_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "controller_image_id" {
  type    = string
  default = ""
}
variable "controller_key_name" {
  type    = string
  default = ""
}

variable "hub_instance_name" {
  type    = string
  default = "hub"
}
variable "hub_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "hub_image_id" {
  type    = string
  default = ""
}
variable "hub_key_name" {
  type    = string
  default = ""
}

variable "database_instance_name" {
  type    = string
  default = "hub"
}
variable "database_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "database_image_id" {
  type    = string
  default = ""
}
variable "database_key_name" {
  type    = string
  default = ""
}

variable "execution_instance_name" {
  type    = string
  default = "execution"
}
variable "execution_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "execution_image_id" {
  type    = string
  default = ""
}
variable "execution_key_name" {
  type    = string
  default = ""
}
