import boto3
import json

def lambda_handler(event, context):
    ec2_client = boto3.client('ec2')
    compliance_status = "COMPLIANT"
    config = json.loads(event['invokingEvent'])
    configuration_item = config["configurationItem"]
    instance_id = configuration_item['configuration']['instanceId']

    try:
        instance = ec2_client.describe_instances(InstanceIds=[instance_id])['Reservations'][0]['Instances'][0]
        if not instance['Monitoring']['State'] == "enabled":
            compliance_status = "NON_COMPLIANT"
    except Exception as e:
        compliance_status = "NON_COMPLIANT"
    
    evaluation = {
        'ComplianceResourceType': 'AWS::EC2::Instance',
        'ComplianceResourceId': instance_id,
        'ComplianceType': compliance_status,
        'Annotation': 'Detailed monitoring is not enabled.',
        'OrderingTimestamp': config['notificationCreationTime']
    }

    config_client = boto3.client('config')
    response = config_client.put_evaluations(
        Evaluations=[evaluation],
        ResultToken=event['resultToken']
    )

    return response
