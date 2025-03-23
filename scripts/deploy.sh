#!/bin/bash

cd templates

STACK_NAME="DisableSerialConsole"

aws cloudformation deploy \
    --template-file sns.yaml \
    --stack-name "$STACK_NAME-sns" \
    --capabilities CAPABILITY_IAM \
    --region eu-west-1

aws cloudformation deploy \
    --template-file lambda.yaml \
    --stack-name "$STACK_NAME-lambda" \
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
    --capabilities CAPABILITY_IAM \
    --region eu-west-1
