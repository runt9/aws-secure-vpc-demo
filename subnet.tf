resource "aws_subnet" "application_public_1" {
    vpc_id            = "${aws_vpc.application.id}"
    cidr_block        = "${var.application_public_1_subnet}"
    availability_zone = "us-west-2a"
}

resource "aws_subnet" "application_public_2" {
    vpc_id            = "${aws_vpc.application.id}"
    cidr_block        = "${var.application_public_2_subnet}"
    availability_zone = "us-west-2b"
}

resource "aws_subnet" "application_private" {
    vpc_id            = "${aws_vpc.application.id}"
    cidr_block        = "${var.application_private_subnet}"
    availability_zone = "us-west-2a"
}

resource "aws_subnet" "database" {
    vpc_id            = "${aws_vpc.database.id}"
    cidr_block        = "${var.database_subnet}"
    availability_zone = "us-west-2a"
}

resource "aws_subnet" "management" {
    vpc_id            = "${aws_vpc.management.id}"
    cidr_block        = "${var.management_subnet}"
    availability_zone = "us-west-2a"
}

