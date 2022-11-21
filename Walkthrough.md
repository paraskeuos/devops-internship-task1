# 1. Start EC2 instance

In AWS web console I opened the EC2 tab and selected launch instance. I picked the free-tier Ubuntu 22.04 AMI.

Further down the menu I created a new key pair which I need for ssh access. Enabled SSH access is selected by default and username is ubuntu.
I downloaded the private .pem file and placed it in my .ssh directory of the WSL container. 
The permissions on the file were too broad so I changed them to 400 with the chmod command.

# 2. Deploy Lambda for EC2 instance start/shutdown at specific times

I went to the Lambda console, created and deployed two separate Python functions for starting and stopping EC2 instances.
Below is the code for stopping instances, the code for starting them is analogous.

```
import boto3
region = 'eu-central-1'
instances = ['i-0f59c5adc39b1ff2b']
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    ec2.stop_instances(InstanceIds=instances)
    print('stopped your instances: ' + str(instances))
```

Before typing in the code and deploying the functions I had to give IAM roles to them in the creation menu.
I selected an existing role which I had created earlier.
Creating the role was straightforward from the given menu since its usage is a common case scenario, but I did add the following policy to it.
First I tried creating the policy without the first object in the statements array but it appears logging permission is mandatory.

![IAM_lambda_policy](https://user-images.githubusercontent.com/57093460/203087006-aa6c348d-82bc-4c99-83bd-1b863288f372.png)

Since I needed my new functions to trigger at specific times, I used EventBridge triggers for each using cron schedules.

This will trigger starting the EC2 instance at 9AM UTC on every workday.
![start_ec2_trigger](https://user-images.githubusercontent.com/57093460/203095674-6d3df1f1-0bf4-408e-a358-dac32a24892b.png)

# 4. Configure SSH for EC2 and git repo

I logged into the new Ubuntu AMI by typing <code>ssh -i ubuntu_key ubuntu@ami-ip</code>, ubuntu_key being the private key filename in my .ssh directory previously downloaded and ami-ip the public IPv4 address assigned to the AMI.

As for ssh repository access, first I created a new key pair using the ssh-keygen command as is also described by Github (under Settings->SSH and GPG keys).
I went to the mentioned page, selected New SSH key, named it and pasted the contents of the newly created public key (ending with .pub).

In order to clone the repository via SSH using a specific key, I typed <code>git config --global core.sshCommand 'ssh -i github_key'</code> (global for the time being since I hadn't cloned the repository to begin with), github_key being the newly made private key.
Then I proceeded with cloning the repository to my machine by typing <code>git clone git@github.com:paraskeuos/devops-internship-task1.git</code>.
