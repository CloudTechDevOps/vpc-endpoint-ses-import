# Define the SNS topic
resource "aws_sns_topic" "ses_bounces" {
  name = "ses-bounce-notifications"
}

# Create an SNS subscription (e.g., email)
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.ses_bounces.arn
  protocol  = "email"
  endpoint  = "chegu.veera232@gmail.com" # Change to your email or other endpoint
}

# Configure SES to publish bounce notifications to the SNS topic
resource "aws_ses_identity_notification_topic" "bounce_notifications" {
  identity = "veerababu.narni232@gmail.com" # Replace with your SES verified email address or domain
  notification_type = "Bounce"
  topic_arn = aws_sns_topic.ses_bounces.arn
}
# Optionally, configure SES to publish complaint and delivery notifications to the SNS topic
# resource "aws_ses_identity_notification_topic" "complaint_notifications" {
#   identity = "veerababu.narni232@gmail.com" # Replace with your SES verified email address or domain
#   notification_type = "Complaint"
#   topic_arn = aws_sns_topic.ses_bounces.arn
# }

# resource "aws_ses_identity_notification_topic" "delivery_notifications" {
#   identity = "veerababu.narni232@gmail.com" # Replace with your SES verified email address or domain
#   notification_type = "Delivery"
#   topic_arn = aws_sns_topic.ses_bounces.arn
# }
