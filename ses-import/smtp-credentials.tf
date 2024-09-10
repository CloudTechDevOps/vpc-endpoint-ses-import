# provider "aws" {
#   region = "us-east-1"  # Change as needed
# }

resource "aws_iam_user" "ses_smtp_user" {
  name = "ses-smtp-user"
}

resource "aws_iam_policy" "ses_send_email" {
  name        = "SES-Send-Email-Policy"
  description = "Policy to allow sending emails with SES"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ses:SendEmail",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_user_policy_attachment" "ses_send_email_attachment" {
  user       = aws_iam_user.ses_smtp_user.name
  policy_arn  = aws_iam_policy.ses_send_email.arn
}

resource "aws_iam_access_key" "ses_smtp_access_key" {
  user = aws_iam_user.ses_smtp_user.name
}

resource "aws_secretsmanager_secret" "ses_smtp_credentials" {
  name        = "ses-smtp-credentials1"
  description = "SMTP credentials for Amazon SES"
}

resource "aws_secretsmanager_secret_version" "ses_smtp_credentials_version" {
  secret_id     = aws_secretsmanager_secret.ses_smtp_credentials.id
  secret_string = jsonencode({
    username = aws_iam_access_key.ses_smtp_access_key.id
    password = aws_iam_access_key.ses_smtp_access_key.secret
  })
}