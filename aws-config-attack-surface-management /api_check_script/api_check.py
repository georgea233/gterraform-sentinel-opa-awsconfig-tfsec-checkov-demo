import boto3
import json

def handler(event, context):
    client = boto3.client('apigateway')
    apis = client.get_rest_apis(limit=100)

    exposed_apis = []
    for api in apis['items']:
        if api['endpointConfiguration']['types'][0] == 'EDGE':  # Public API
            exposed_apis.append(api['id'])

    return {
        'statusCode': 200,
        'body': json.dumps({
            'exposedApis': exposed_apis
        })
    }
