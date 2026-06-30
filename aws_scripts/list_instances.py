import boto3

def list_instances():
    # Create an EC2 client
    # It automatically uses the credentials from your 'aws configure'
    ec2 = boto3.client('ec2', region_name='ap-south-1')

    print("--- Fetching EC2 Instances ---")
    
    # Call the AWS API
    response = ec2.describe_instances()

    # AWS returns a complex dictionary. We loop through it to find our data.
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            state = instance['State']['Name']
            public_ip = instance.get('PublicIpAddress', 'No Public IP')
            
            print(f"ID: {instance_id} | State: {state} | IP: {public_ip}")

if __name__ == "__main__":
    list_instances()
