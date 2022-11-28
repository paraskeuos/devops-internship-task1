import boto3
import os

ec2_arn = os.environ.get('EC2_ARN')
instances = [ ec2_arn.split('/')[-1] ]

client = boto3.client('ec2')

def lambda_handler(event, context):
    client.start_instances(InstanceIds=instances)