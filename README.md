# AWS EC2 serial console rule for AWS Config

## Description
This repository contains CloudFormation templates that deploy an AWS Config rule that checks if the EC2 serial console setting is enabled with a lambda function. If it is enabled, the rule will be non-compliant and will send an email notification to specified email address. It also allows for manual remediation using SSM automation document.

## Prerequisites
* AWS CLI configured
* `zip` for packaging the lambda function

## Structure
* `lambda/rule.py` - contains the lambda function for AWS Config rule, checks if the EC2 serial console setting is enabled. If it is enabled, the rule will be non-compliant and will send an email notification to specified email address.
* `scripts/` - contains utility scripts
    * `publish.sh` - script to publish the lambda function to an S3 bucket
    * `deploy.sh` - script to deploy CloudFormation templates
* `templates/` - contains the CloudFormation templates
    * `config.yaml` - creates AWS Config rule and remediation action
    * `lambda.yaml` - creates lambda function for AWS Config rule with necessary roles and permissions
    * `sns.yaml` - creates SNS topic and subscription for notification when AWS Config rule is non-compliant
    * `ssm.yaml` - creates SSM automation document for manual remediation of AWS config rule


## Steps
1. Publish the lambda function to an S3 bucket
```
./scripts/publish.sh <BUCKET_NAME>
```
2. Deploy the CloudFormation template
```
./scripts/deploy.sh <STACK_NAME> <BUCKET_NAME> <EMAIL_ADDRESS>
```
* `<STACK_NAME>` is the name of the CloudFormation stack, 
* `<BUCKET_NAME>` is the name of the S3 bucket where the lambda function is published, 
* `<EMAIL_ADDRESS>` is the email address to send the notification to.