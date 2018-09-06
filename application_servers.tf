data "aws_ami" "aws_demo_ami" {
    most_recent = true
    owners      = ["202559324580"]

    filter {
        name   = "name"
        values = ["aws-demo-*"]
    }
}

resource "aws_instance" "application" {
    ami                    = "${data.aws_ami.aws_demo_ami.id}"
    instance_type          = "t2.micro"
    subnet_id              = "${aws_subnet.application_private.id}"
    vpc_security_group_ids = ["${aws_security_group.application_private.id}"]
    key_name               = "aws_demo"
}

resource "aws_lb_target_group_attachment" "application_server_1" {
    target_group_arn = "${aws_lb_target_group.application.arn}"
    target_id        = "${aws_instance.application.id}"
}