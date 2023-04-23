import json

import boto3

def lambda_handler(event, context):
    # Create response body
    response_body = {
        "message": f"Hello, World!",
        "input": event
    }

    # Create API Gateway response
    response = {
        "statusCode": 200,
        "body": json.dumps(response_body)
    }

    return response