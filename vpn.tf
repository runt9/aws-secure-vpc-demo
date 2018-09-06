resource "aws_vpn_gateway" "management" {
    vpc_id = "${aws_vpc.management.id}"
}

