import boto3
import datetime

def lambda_handler(event, context):
    config_client = boto3.client('config')
    ec2_client = boto3.client('ec2')

    serial_console_access_enabled = ec2_client.get_serial_console_access_status()['SerialConsoleAccessEnabled']
    
    compliance_type = 'NON_COMPLIANT' if serial_console_access_enabled else 'COMPLIANT'

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

    print(response)