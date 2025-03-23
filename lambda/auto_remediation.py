import boto3

def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    serial_console_access_enabled = ec2_client.get_serial_console_access_status()['SerialConsoleAccessEnabled']
    
    if serial_console_access_enabled:
        print("Serial console access is enabled. Disabling...")
        ec2_client.disable_serial_console_access()
    else:
        print("Serial console access is already disabled.")
