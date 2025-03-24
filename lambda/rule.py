import boto3
import datetime
import json
import os

def lambda_handler(event, context):
    config_client = boto3.client('config')
    ec2_client = boto3.client('ec2')

    serial_console_access_enabled = ec2_client.get_serial_console_access_status()['SerialConsoleAccessEnabled']
    
    compliance_type = 'NON_COMPLIANT' if serial_console_access_enabled else 'COMPLIANT'
    
    print(compliance_type)
    
    response = config_client.put_evaluations(
        Evaluations=[
            {
                'ComplianceType': compliance_type,
                'ComplianceResourceType': 'AWS::::Account',
                'ComplianceResourceId': event['accountId'],
                'OrderingTimestamp': datetime.datetime.now()
            }
        ],
        ResultToken=event['resultToken']
    )

    if compliance_type == 'NON_COMPLIANT':
        sns_client = boto3.client('sns')

        sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')

        message = (
            "EC2 Serial Console Access Compliance Alert\n\n"
            f"EC2 serial console enabled in AWS account (ID: {event['accountId']}).\n\n"
            "Details:\n"
            f"Account ID: {event['accountId']}\n"
            "Compliance Status: NON_COMPLIANT\n"
            f"Timestamp: {datetime.datetime.now().isoformat()}\n\n"
            "Use AWS config remediation to disable it."
        )

        print(message)
    
        sns_response = sns_client.publish(
            TopicArn=sns_topic_arn,
            Message=message,
            Subject='EC2 Serial Console Access Compliance Alert'
        )

        print(f"SNS notification sent: {sns_response}")

    return { 'complianceType': compliance_type }