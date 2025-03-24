#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: ./publish.sh <BUCKET_NAME>"
    exit 1
fi

BUCKET_NAME="$1"

cd lambda
zip rule.zip rule.py
aws s3 cp rule.zip s3://$BUCKET_NAME/
echo "Successfully published Lambda functions to s3://$BUCKET_NAME/"
rm rule.zip