resource "aws_route_table" "data_center" {
  vpc_id = "${aws_vpc.main.id}"

  # Allow the NAT gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.data_center_nat.id}"
  }

  tags {
    Name        = "${var.environment} subnet"
    Environment = "${var.environment}"
  }
}

resource "aws_subnet" "data_center_subnet" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.subnet_range}"
  availability_zone       = "${var.availablitiy_zone}"
	
  tags {
    Name        = "${var.environment} ${var.availablitiy_zone}"
    Environment = "${var.environment}"
  }
	lifecycle {
		create_before_destroy = true
	}
}

resource "aws_route_table_association" "main_subnet_route" {
  subnet_id = "${aws_subnet.data_center_subnet.id}"
  route_table_id = "${aws_route_table.data_center.id}"
}

# NAT Gateway
resource "aws_eip" "nat_ip_address" {
    vpc = true
}

resource "aws_nat_gateway" "data_center_nat" {
    allocation_id = "${aws_eip.nat_ip_address.id}"
    subnet_id = "${aws_subnet.data_center_subnet.id}"

    # tags {	
	# 	Name = "${var.environment} nat gateway"
	# 	Environment = "${var.environment}"
    # }

    depends_on = ["aws_internet_gateway.data_center_gateway"]
}

# Add ACL and ACL rules for the Nat gateway
resource "aws_network_acl" "access_control_list" {    
    vpc_id = "${aws_vpc.main.id}"
    subnet_ids = [ "${aws_subnet.data_center_subnet.id}"]
	tags {	
		Name = "${var.environment} nat acl rule"
		Environment = "${var.environment}"
    }
}

# Allow inbound connections from inside the VPC to port 80, 443 on the NAT gateway
resource "aws_network_acl_rule" "http_vpc_in" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 100
    egress = false
    protocol = "tcp"
    rule_action = "allow"
	from_port = "80"
	to_port = "80"
    cidr_block = "${var.vpc_range}"
}

resource "aws_network_acl_rule" "https_vpc_in" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 110
    egress = false
    protocol = "tcp"
    rule_action = "allow"
	from_port = "443"
	to_port = "443"
    cidr_block = "${var.vpc_range}"
}

# Allow inbound internet connections to the NAT on port range 1024 to 65535
resource "aws_network_acl_rule" "ephemeral_in" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 120
    egress = false
    protocol = "tcp"
    rule_action = "allow"
	from_port = "1024"
	to_port = "65535"
    cidr_block = "0.0.0.0/0"
}

# Allow outbound connections on the NAT gateway for port 80, 443 and range 1024 to 65535 
resource "aws_network_acl_rule" "http_www_out" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 100
    egress = true
    protocol = "tcp"
    rule_action = "allow"
	from_port = "80"
	to_port = "80"
    cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "https_www_out" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 110
    egress = true
    protocol = "tcp"
    rule_action = "allow"
	from_port = "443"
	to_port = "443"
    cidr_block = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "ephemeral_out" {
    network_acl_id = "${aws_network_acl.access_control_list.id}"
    rule_number = 120
    egress = true
    protocol = "tcp"
    rule_action = "allow"
	from_port = "1024"
	to_port = "65535"
	cidr_block = "0.0.0.0/0"
}