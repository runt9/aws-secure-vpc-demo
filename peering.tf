resource "aws_vpc_peering_connection" "application_to_database" {
    vpc_id      = "${aws_vpc.application.id}"
    peer_vpc_id = "${aws_vpc.database.id}"
    auto_accept = true
}

resource "aws_vpc_peering_connection" "management_to_application" {
    vpc_id      = "${aws_vpc.management.id}"
    peer_vpc_id = "${aws_vpc.application.id}"
    auto_accept = true
}

resource "aws_vpc_peering_connection" "management_to_database" {
    vpc_id      = "${aws_vpc.management.id}"
    peer_vpc_id = "${aws_vpc.database.id}"
    auto_accept = true
}
