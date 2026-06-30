import boto3
import time

def manage_s3():
    s3 = boto3.client('s3', region_name='ap-south-1')
    
    # 1. Pick a unique name
    bucket_name = f"boto3-lab-test-{int(time.time())}"
    
    print(f"--- Creating bucket: {bucket_name} ---")
    # In ap-south-1 (Mumbai), we need LocationConstraint
    s3.create_bucket(
        Bucket=bucket_name,
        CreateBucketConfiguration={'LocationConstraint': 'ap-south-1'}
    )
    
    # 2. List to verify
    print("Listing buckets:")
    response = s3.list_buckets()
    for bucket in response['Buckets']:
        print(f"  - {bucket['Name']}")
        
    # 3. Delete the bucket
    print(f"--- Deleting bucket: {bucket_name} ---")
    s3.delete_bucket(Bucket=bucket_name)
    
    print("Done!")

if __name__ == "__main__":
    manage_s3()
