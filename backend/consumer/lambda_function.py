import json
import os
import uuid

import boto3

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ["TABLE_NAME"]
table = dynamodb.Table(TABLE_NAME)


def lambda_handler(event, context):
    for record in event["Records"]:
        body = json.loads(record["body"])

        item = {
            "fileId": body.get("fileId") or str(uuid.uuid4()),
            "fileName": body["fileName"],
            "category": body["category"],
            "size": int(body["size"]),
        }

        table.put_item(Item=item)

    return {"statusCode": 200}
