from aws_cdk import (
    Stack,
    aws_s3 as s3,
    RemovalPolicy,
)
from constructs import Construct

class CdkLabStack(Stack):

    def __init__(self, scope: Construct, construct_id: str, **kwargs) -> None:
        super().__init__(scope, construct_id, **kwargs)

        # Create an S3 Bucket using Python code
        s3.Bucket(self, "MyFirstCdkBucket",
            versioned=True,
            # This ensures the bucket is deleted when we delete the stack
            removal_policy=RemovalPolicy.DESTROY,
            # This ensures the bucket is actually deleted even if it has files
            auto_delete_objects=True
        )
