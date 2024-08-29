provider "aws" {
  region = "us-east-1"
}


resource "aws_ses_configuration_set" "ses_config" {
  name = "config_ses"
  reputation_metrics_enabled = true
}

resource "aws_ses_domain_identity" "domain_identity" {
  domain = var.domain_name
}

resource "aws_ses_domain_dkim" "dkim_identity" {
  domain = aws_ses_domain_identity.domain_identity.domain
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count   = 3
  zone_id = aws_route53_zone.route_53_zone.zone_id
  name    = "${aws_ses_domain_dkim.dkim_identity.dkim_tokens[count.index]}._domainkey.${aws_ses_domain_identity.domain_identity.domain}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_ses_domain_dkim.dkim_identity.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

resource "aws_ses_domain_identity_verification" "domain_identity_verification" {
  domain = aws_ses_domain_identity.domain_identity.id
  depends_on = [aws_route53_record.amazonses_dkim_record]
}

resource "aws_ses_email_identity" "email_identity" {
  email = "awscloud1211@gmail.com"
}

resource "aws_route53_zone" "route_53_zone" {
  name = var.domain_name
}

#variables.tf
variable "domain_name" {
  type = string
  default = "narni.co.in"
}