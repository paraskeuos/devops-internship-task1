// Start EC2 trigger

resource "aws_cloudwatch_event_rule" "start_ec2_trigger_rule" {
  name = "StartEC2Trigger"
  schedule_expression = "cron(0 8 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "start_ec2_trigger_target" {
  rule      = aws_cloudwatch_event_rule.start_ec2_trigger_rule.name
  arn       = aws_lambda_function.lambda_start_ec2.arn
  depends_on = [
    aws_lambda_function.lambda_start_ec2
  ]
}

// Stop EC2 trigger

resource "aws_cloudwatch_event_rule" "stop_ec2_trigger_rule" {
  name = "StopEC2Trigger"
  schedule_expression = "cron(0 11 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "stop_ec2_trigger_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_trigger_rule.name
  arn       = aws_lambda_function.lambda_stop_ec2.arn
  depends_on = [
    aws_lambda_function.lambda_stop_ec2
  ]
}