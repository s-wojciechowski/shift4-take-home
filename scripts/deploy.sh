#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <STACK_NAME> <BUCKET_NAME> <EMAIL_ADDRESS>"
    exit 1
fi

STACK_NAME="$1"
BUCKET_NAME="$2"
EMAIL_ADDRESS="$3"

cd templates

aws cloudformation deploy \
    --template-file sns.yaml \
    --stack-name "$STACK_NAME-sns" \
    --parameter-overrides EmailAddress="$EMAIL_ADDRESS" \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

aws cloudformation deploy \
    --template-file lambda.yaml \
    --stack-name "$STACK_NAME-lambda" \
    --parameter-overrides SNSStackName="$STACK_NAME-sns" S3BucketName="$BUCKET_NAME" \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

aws cloudformation deploy \
    --template-file ssm.yaml \
    --stack-name "$STACK_NAME-ssm" \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

aws cloudformation deploy \
    --template-file config.yaml \
    --stack-name "$STACK_NAME-config" \
    --parameter-overrides LambdaStackName="$STACK_NAME-lambda" SSMStackName="$STACK_NAME-ssm" \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1
