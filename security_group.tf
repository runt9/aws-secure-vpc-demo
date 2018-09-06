resource "aws_security_group" "application_public" {
    name        = "Application Public"
    description = "Traffic to/from Load Balancer"
    vpc_id      = "${aws_vpc.application.id}"

    # Allow all incoming HTTP and HTTPS traffic
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }

    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }

    # Allow anything in this security group to talk to anything else in this security group
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }
}

resource "aws_security_group" "application_private" {
    name        = "Application Private"
    description = "Traffic to/from Application Servers"
    vpc_id      = "${aws_vpc.application.id}"

    # Allow incoming SSH from management VPC
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["${var.management_vpc_cidr}"]
    }

    # Allow incoming SSH from my machine
    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks = ["76.85.68.157/32"]
    }

    # Allow incoming traffic from the Load Balancer on port 8000
    ingress {
        from_port   = 8000
        to_port     = 8000
        protocol    = "tcp"
        security_groups = ["${aws_security_group.application_public.id}"]
    }

    # Allow anything in this security group to talk to anything else in this security group
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }
}
resource "aws_security_group" "database" {
    name        = "Database"
    description = "Traffic to/from Database servers"
    vpc_id      = "${aws_vpc.database.id}"

    # Allow incoming PostgreSQL traffic from private application servers
    ingress {
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = ["${var.application_private_subnet}"]
    }

    # Allow incoming SSH traffic from management server
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.management_vpc_cidr}"]
    }

    # Allow anything in this security group to talk to anything else in this security group
    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }

}

resource "aws_security_group" "management" {
    name        = "Management"
    description = "Traffic to/from management servers"
    vpc_id      = "${aws_vpc.management.id}"

    ingress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"
        self      = true
    }

    # Incoming SSH from management servers
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.management_subnet}"]
    }

    # Allow outgoing HTTP and HTTPS for updates. We don't allow all outgoing traffic in order to minimize attack vectors
    egress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }

    egress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["${var.all_traffic_cidr}"]
    }

    # Outgoing SSH to Application and Database VPCs
    egress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.application_private_subnet}", "${var.database_subnet}"]
    }
}


