resource "aws_internet_gateway" "application" {
    vpc_id = "${aws_vpc.application.id}"
}

resource "aws_internet_gateway" "database" {
    vpc_id = "${aws_vpc.database.id}"
}