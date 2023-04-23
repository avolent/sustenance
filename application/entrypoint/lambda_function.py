import json

def lambda_handler(event, context):
    # Parse input from API Gateway event
    query_parameters = event["queryStringParameters"]

    # Extract value for "name" parameter
    name = query_parameters.get("name", "Unknown")

    # Create response body
    response_body = {
        "message": f"Hello, {name}!",
        "input": event
    }

    # Create API Gateway response
    response = {
        "statusCode": 200,
        "body": json.dumps(response_body)
    }

    return response