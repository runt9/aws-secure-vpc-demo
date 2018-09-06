#region Application Public
resource "aws_route_table" "application_public" {
    vpc_id = "${aws_vpc.application.id}"

    route {
        cidr_block = "${var.all_traffic_cidr}"
        gateway_id = "${aws_internet_gateway.application.id}"
    }
}

resource "aws_route_table_association" "application_public_1" {
    route_table_id = "${aws_route_table.application_public.id}"
    subnet_id      = "${aws_subnet.application_public_1.id}"
}

resource "aws_route_table_association" "application_public_2" {
    route_table_id = "${aws_route_table.application_public.id}"
    subnet_id      = "${aws_subnet.application_public_2.id}"
}
#endregion

#region Application Private
resource "aws_route_table" "application_private" {
    vpc_id = "${aws_vpc.application.id}"

    route {
        cidr_block     = "${var.all_traffic_cidr}"
        nat_gateway_id = "${aws_nat_gateway.application_private.id}"
    }

    route {
        cidr_block                = "${var.database_vpc_cidr}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.application_to_database.id}"
    }
}

resource "aws_route_table_association" "application_private" {
    route_table_id = "${aws_route_table.application_private.id}"
    subnet_id      = "${aws_subnet.application_private.id}"
}
#endregion

#region Database
resource "aws_route_table" "database" {
    vpc_id = "${aws_vpc.database.id}"

    route {
        cidr_block     = "${var.all_traffic_cidr}"
        nat_gateway_id = "${aws_nat_gateway.database.id}"
    }
}

resource "aws_route_table_association" "database" {
    route_table_id = "${aws_route_table.database.id}"
    subnet_id      = "${aws_subnet.database.id}"
}
#endregion

#region Management
resource "aws_route_table" "management" {
    vpc_id           = "${aws_vpc.management.id}"

    route {
        cidr_block                = "${var.application_vpc_cidr}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_application.id}"
    }

    route {
        cidr_block                = "${var.database_vpc_cidr}"
        vpc_peering_connection_id = "${aws_vpc_peering_connection.management_to_database.id}"
    }

    route {
        cidr_block = "${var.all_traffic_cidr}"
        gateway_id = "${aws_vpn_gateway.management.id}"
    }

    propagating_vgws = ["${aws_vpn_gateway.management.id}"]
}

resource "aws_route_table_association" "management" {
    route_table_id = "${aws_route_table.management.id}"
    subnet_id      = "${aws_subnet.management.id}"
}
#endregion