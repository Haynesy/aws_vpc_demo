# Routing for the public subnet
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  # Attach the VPC Internet gateway and allow it to talk to 0.0.0.0/0 (Also known as the internet)
  # This connection is what makes it a public subnet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.data_center_gateway.id}" 
  }

  tags {
    Name        = "${var.environment} public route table"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
}

# The public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id                  = "${aws_vpc.main.id}"
    cidr_block              = "${var.public_subnet_range}"
    availability_zone       = "${var.availablitiy_zone}"
	  map_public_ip_on_launch = true # Create an IP address automatically

	  tags {
      Name        = "${var.environment} ${var.availablitiy_zone}"
      Environment = "${var.environment}"
      Terraform = "true"
    }
    lifecycle {
		  create_before_destroy = true
	  }
}

# Attach the public route table to the subnet
resource "aws_route_table_association" "main" {
  subnet_id = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public.id}"
}