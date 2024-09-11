# CloudWatch Metric for SES Bounce Rate
resource "aws_cloudwatch_metric_alarm" "ses_bounce_rate" {
  alarm_name          = "HighBounceRate"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Bounce"
  namespace           = "AWS/SES"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1    # Trigger the alarm when there is at least 1 bounce
  alarm_actions       = [aws_sns_topic.ses_bounces.arn]

  dimensions = {
    "Identity" = "veerababu.narni232@gmail.com"  # Replace with your SES identity
  }

  # Set alarm description
  alarm_description = "Alarm for bounce rate exceeding threshold."
}


resource "aws_cloudwatch_metric_alarm" "ses_bounce_rate_email1" {
  alarm_name          = "HighBounceRate_Email1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Bounce"
  namespace           = "AWS/SES"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1    # Trigger the alarm when there is at least 1 bounce
  alarm_actions       = [aws_sns_topic.ses_bounces.arn]

  dimensions = {
    "Identity" = "email1@example.com"  # Replace with the first SES identity
  }

  alarm_description = "Alarm for bounce rate exceeding threshold for email1."
}

resource "aws_cloudwatch_metric_alarm" "ses_bounce_rate_email2" {
  alarm_name          = "HighBounceRate_Email2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Bounce"
  namespace           = "AWS/SES"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1    # Trigger the alarm when there is at least 1 bounce
  alarm_actions       = [aws_sns_topic.ses_bounces.arn]

  dimensions = {
    "Identity" = "email2@example.com"  # Replace with the second SES identity
  }

  alarm_description = "Alarm for bounce rate exceeding threshold for email2."
}

resource "aws_cloudwatch_metric_alarm" "ses_bounce_rate_email3" {
  alarm_name          = "HighBounceRate_Email3"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Bounce"
  namespace           = "AWS/SES"
  period              = 300  # 5 minutes
  statistic           = "Sum"
  threshold           = 1    # Trigger the alarm when there is at least 1 bounce
  alarm_actions       = [aws_sns_topic.ses_bounces.arn]

  dimensions = {
    "Identity" = "email3@example.com"  # Replace with the third SES identity
  }

  alarm_description = "Alarm for bounce rate exceeding threshold for email3."
}
