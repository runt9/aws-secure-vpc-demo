resource "aws_eip" "application_private_nat" {
    vpc = true
}

resource "aws_eip" "database_nat" {
    vpc = true
}