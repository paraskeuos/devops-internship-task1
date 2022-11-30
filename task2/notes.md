# Terraform - env variables and authentication

```
export AWS_DEFAULT_REGION=...
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
```

# Terraform provider specification

Use new syntax:

```
terraform {
    required_providers {
        aws = {
	    source = "hashicorp/aws"
	    version = "~> 4.0"
	}
    }
}
```

# aws_lambda_permission

Lambda function and trigger won't connect if optional argument <code>source_arn</code> isn't provided.

```
resource "aws_lambda_permission" "start_ec2_allow_cloudwatch" {
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.lambda_start_ec2.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.start_ec2_trigger_rule.arn
}
```