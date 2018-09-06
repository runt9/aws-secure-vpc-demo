resource "aws_lb_target_group" "application" {
    name     = "application"
    # NB: We would obviously send this traffic over HTTPS as well, but setting up the cert on the EC2 instance
    # is a little out of scope for this project since it would involve pulling it down from AWS on the server
    # and setting up Apache/Nginx/etc.
    port     = 8000
    protocol = "HTTP"
    vpc_id   = "${aws_vpc.application.id}"
}

resource "aws_lb" "application" {
    name            = "application"
    security_groups = ["${aws_security_group.application_public.id}"]
    subnets         = ["${aws_subnet.application_public_1.id}", "${aws_subnet.application_public_2.id}"]
}

resource "aws_alb_listener" "application_https" {
    load_balancer_arn = "${aws_lb.application.arn}"
    port              = 443
    protocol          = "HTTPS"
    certificate_arn   = "${aws_acm_certificate_validation.cert_validation.certificate_arn}"

    default_action {
        type             = "forward"
        target_group_arn = "${aws_lb_target_group.application.arn}"
    }
}

# HTTP automatically redirects to HTTPS
resource "aws_alb_listener" "application_http" {
    load_balancer_arn = "${aws_lb.application.arn}"
    port              = 80
    protocol          = "HTTP"

    default_action {
        type = "redirect"
        redirect {
            port        = "443"
            protocol    = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Certificate stuff to do SSL on AWS LB
resource "aws_acm_certificate" "aws_demo_ssl_cert" {
    domain_name       = "aws-demo.runt9.tk"
    validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "cert_validation" {
    certificate_arn         = "${aws_acm_certificate.aws_demo_ssl_cert.arn}"
    validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}