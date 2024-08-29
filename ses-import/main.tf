provider "aws" {
  region = "us-east-1"
}
# resource "aws_ses_configuration_set" "ses_config" {
#   name = "config_ses"
#   reputation_metrics_enabled = true
# }

resource "aws_ses_domain_identity" "domain_identity" {
  # domain = "vardhan.live"
}

resource "aws_ses_domain_dkim" "dkim_identity" {
  # domain = aws_ses_domain_identity.domain_identity.domain
}

resource "aws_ses_email_identity" "email_identity" {
  # email = "awscloud1211@gmail.com"
}

resource "aws_route53_zone" "route_53_zone" {
  # name = "vardhan.live"
}