#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: Please provide an S3 bucket name as an argument"
    echo "Usage: ./publish.sh BUCKET_NAME"
    exit 1
fi

BUCKET_NAME="$1"

cd lambda

zip rule.zip rule.py
zip auto_remediation.zip auto_remediation.py

echo "Uploading zip files to s3://$BUCKET_NAME/"
aws s3 cp rule.zip s3://$BUCKET_NAME/
aws s3 cp auto_remediation.zip s3://$BUCKET_NAME/

echo "Successfully published Lambda functions to s3://$BUCKET_NAME/"

rm rule.zip auto_remediation.zip