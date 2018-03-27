# Look it's your very own Virtual Private Cloud
resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_range}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags {
    Name        = "${var.environment} vpc"
    Environment = "${var.environment}"
  }
}

# An internet gateway this needs to be attached to your VPC
# The subnet you attach this to determins if that subnet is public
resource "aws_internet_gateway" "data_center_gateway" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.environment} www gateway"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}