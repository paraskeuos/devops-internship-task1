// EC2 instance public key for upload

resource "aws_key_pair" "instance_key_pair" {
  key_name   = "tf_ubuntu"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZnYpd+cs72XeF2RRqCQTBN3k52uCAAOlUaKCwb37fqzDIykzpt3OSm1z0ilCgsf1Bws0Y1vRiNnrn2WMQF+1gfD/ftwB0wm2/xrWY2Ql50yirStbyO/Oj6xFViIzu32ZFhLWMBS7wenRWJziD3qQf4A5a2XgWO/5fnCWet/wXevoI4gS+DfkLPcRRclM+2+7d0kKvHdyzJWUsZkrH8x952dbyeOP1/cl9oIhFv4RSvAd0kj5MwkAlFJ4klpFsIW3LEdg3+cwwW4yJjyjvY/I071B15uclsiYkEqVsqKmsyt0UeJ3Gakc7QuR5JPo38niJms7AYMcD7jIKxlaZHZGFWShLxI+RSTCOF0XK0MQV1oTEHSS3AH99iVb/Oe9FpEjw6mbWaxmxwAC0012FcLryfzNcdJcIAGlpWA9KhllwaID39eopXAeMsHnxedXVySsHIoODDeSOPn/DcenwtU0INF1mJmihmOJK9UZVeUubLq7IvJpWTU9/L74kb6yqy3s= mradisic@ENDAUTOWl97MVe5"
}

// Role and policies for lambda functions

resource "aws_iam_role" "iam_lambda" {
  name = "LambdaStartStopEC2Role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  
  inline_policy {
    name = "LambdaStartStopEC2Policy"
    policy = data.aws_iam_policy_document.lambda_permissions.json
  }
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [ "arn:aws:logs:*:*:*" ]
  }

  statement {
    actions = [
      "ec2:Start*",
      "ec2:Stop*"
    ]

    resources = [ "*" ]
  }
}