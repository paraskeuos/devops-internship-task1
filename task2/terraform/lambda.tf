// Start EC2 lambda

data "archive_file" "py_lambda_start_ec2" {
  type = "zip"
  source_file = "src/start_instance.py"
  output_path = "src/ec2_start.zip"
}

resource "aws_lambda_function" "lambda_start_ec2" {
  function_name = "LambdaStartEC2"
  filename = "src/ec2_start.zip"
  source_code_hash = filebase64sha256("src/ec2_start.zip")
  role = aws_iam_role.iam_lambda.arn
  runtime = "python3.9"
  handler = "start_instance.lambda_handler"

  environment {
    variables = {
      EC2_ARN = aws_instance.jenkins_server.arn
    }
  }
}

resource "aws_lambda_permission" "start_ec2_allow_cloudwatch" {
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.lambda_start_ec2.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.start_ec2_trigger_rule.arn
}

// Stop EC2 lambda

data "archive_file" "py_lambda_stop_ec2" {
  type = "zip"
  source_file = "src/stop_instance.py"
  output_path = "src/ec2_stop.zip"
}

resource "aws_lambda_function" "lambda_stop_ec2" {
  function_name = "LambdaStopEC2"
  filename = "src/ec2_stop.zip"
  source_code_hash = filebase64sha256("src/ec2_stop.zip")
  role = aws_iam_role.iam_lambda.arn
  runtime = "python3.9"
  handler = "stop_instance.lambda_handler"

  environment {
    variables = {
      EC2_ARN = aws_instance.jenkins_server.arn
    }
  }
}

resource "aws_lambda_permission" "stop_ec2_allow_cloudwatch" {
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.lambda_stop_ec2.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.stop_ec2_trigger_rule.arn
}