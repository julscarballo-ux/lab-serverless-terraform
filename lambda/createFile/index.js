const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");
const { randomUUID } = require("crypto");

const client = DynamoDBDocumentClient.from(new DynamoDBClient({}));
const TABLE = "Files";

const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type,Authorization,x-api-key",
  "Content-Type": "application/json",
};

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body || "{}");
    const { fileName, category, size } = body;

    if (!fileName || !category || !size) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ message: "fileName, category y size son obligatorios" }),
      };
    }

    const item = {
      fileId: randomUUID(),
      fileName,
      category,
      size: Number(size),
    };

    await client.send(new PutCommand({ TableName: TABLE, Item: item }));

    return {
      statusCode: 201,
      headers,
      body: JSON.stringify(item),
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ message: error.message }),
    };
  }
};
