data "aws_ami" "rhel_8" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-8.7*Hourly*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

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
