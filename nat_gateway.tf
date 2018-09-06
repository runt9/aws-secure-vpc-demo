resource "aws_nat_gateway" "application_private" {
    allocation_id = "${aws_eip.application_private_nat.id}"
    subnet_id     = "${aws_subnet.application_private.id}"
}

resource "aws_nat_gateway" "database" {
    allocation_id = "${aws_eip.database_nat.id}"
    subnet_id     = "${aws_subnet.database.id}"
}