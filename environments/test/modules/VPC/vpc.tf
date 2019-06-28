resource "aws_vpc" "MyVPC" {
  cidr_block            = "${var.vpc_cidr_block}"
  instance_tenancy      = "default"
  enable_dns_support    = "${var.enable_dns_support}"
  enable_dns_hostnames  = "${var.enable_dns_hostnames}"

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id                  = "${aws_vpc.MyVPC.id}"
  cidr_block              = var.public_subnet_cidr_block
#  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
#  availability_zone       = var.public_subnet_availability_zone
#
  tags = {
    Name = "Public"
  }
}
