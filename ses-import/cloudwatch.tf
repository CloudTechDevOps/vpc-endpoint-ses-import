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
