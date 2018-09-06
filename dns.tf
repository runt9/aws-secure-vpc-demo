# This isn't created automatically. This is for my free runt9.tk domain I setup for this.
# This block will pull the zone info from AWS that is "hardcoded" and use it to do the
# certificate validation and create the proper CNAME record for the load balancer
data "aws_route53_zone" "runt9_zone" {
    name         = "runt9.tk."
    private_zone = false
}

resource "aws_route53_record" "aws_demo_record" {
    name    = "aws-demo.runt9.tk"
    type    = "CNAME"
    zone_id = "${data.aws_route53_zone.runt9_zone.id}"
    records = ["${aws_lb.application.dns_name}"]
    ttl     = 60
}

resource "aws_route53_record" "cert_validation" {
    name    = "${aws_acm_certificate.aws_demo_ssl_cert.domain_validation_options.0.resource_record_name}"
    type    = "${aws_acm_certificate.aws_demo_ssl_cert.domain_validation_options.0.resource_record_type}"
    zone_id = "${data.aws_route53_zone.runt9_zone.id}"
    records = ["${aws_acm_certificate.aws_demo_ssl_cert.domain_validation_options.0.resource_record_value}"]
    ttl     = 60
}