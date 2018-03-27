resource "aws_route_table" "data_center" {
  vpc_id = "${aws_vpc.main.id}"

  # Allow the NAT gateway to talk to 0.0.0.0/0 (Also known as the internet)
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.data_center_nat.id}"
  }

  tags {
    Name        = "${var.environment} subnet"
    Environment = "${var.environment}"
  }
}

// Create Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.private_subnet_range}"
  availability_zone       = "${var.availablitiy_zone}"
	
  tags {
    Name        = "${var.environment} ${var.availablitiy_zone} private"
    Environment = "${var.environment}"
  }
	lifecycle {
		create_before_destroy = true
	}
}

// Associate private subnet and private route table
resource "aws_route_table_association" "main_subnet_route" {
  subnet_id = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.data_center.id}"
}
