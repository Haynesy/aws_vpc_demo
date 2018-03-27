
# NAT Gateway static IP address
resource "aws_eip" "nat_ip_address" {
    vpc = true
}

# The NAT gateway note that it sits in the publis subnet
resource "aws_nat_gateway" "data_center_nat" {
    allocation_id = "${aws_eip.nat_ip_address.id}"
    subnet_id = "${aws_subnet.public_subnet.id}"

    depends_on = ["aws_internet_gateway.data_center_gateway"]
}
