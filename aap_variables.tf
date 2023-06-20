variable "aap_aws_region" {
  type    = string
  default = "us-east-2"
}
variable "use_rhel_9" {
  type    = bool
  default = false
}
variable "disconnected" {
  type    = bool
  default = false
}

variable "aap_vpc_cidr" {
  type    = string
  default = "10.255.0.0/24"
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
variable "controller_count" {
  type    = number
  default = "1"
}
variable "controller_image_id" {
  type    = string
  default = ""
}
variable "controller_key_name" {
  type    = string
  default = ""
}
variable "controller_disk_size" {
  type    = number
  default = 40
}

variable "hub_instance_name" {
  type    = string
  default = "hub"
}
variable "hub_count" {
  type    = number
  default = "1"
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
variable "hub_disk_size" {
  type    = number
  default = 40
}

variable "database_instance_name" {
  type    = string
  default = "hub"
}
variable "database_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "database_count" {
  type    = number
  default = "0"
}
variable "database_image_id" {
  type    = string
  default = ""
}
variable "database_key_name" {
  type    = string
  default = ""
}
variable "database_disk_size" {
  type    = number
  default = 40
}

variable "execution_instance_name" {
  type    = string
  default = "execution"
}
variable "execution_instance_type" {
  type    = string
  default = "t3.xlarge"
}
variable "execution_count" {
  type    = number
  default = "0"
}
variable "execution_image_id" {
  type    = string
  default = ""
}
variable "execution_key_name" {
  type    = string
  default = ""
}
variable "execution_disk_size" {
  type    = number
  default = 40
}
