# NB: As it turns out, there are Terraform modules to do this easier.
# Really we should be setting the Name tag on literally everything so it's easier to look at in the console
resource "aws_vpc" "application" {
    cidr_block = "${var.application_vpc_cidr}"
}

resource "aws_vpc" "database" {
    cidr_block = "${var.database_vpc_cidr}"
}

resource "aws_vpc" "management" {
    cidr_block = "${var.management_vpc_cidr}"
}