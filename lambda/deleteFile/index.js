const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, DeleteCommand } = require("@aws-sdk/lib-dynamodb");

const client = DynamoDBDocumentClient.from(new DynamoDBClient({}));
const TABLE = "Files";

const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type,Authorization,x-api-key",
  "Content-Type": "application/json",
};

exports.handler = async (event) => {
  try {
    const fileId = event.pathParameters?.id;

    if (!fileId) {
      return {
        statusCode: 400,
        headers,
        body: JSON.stringify({ message: "id es obligatorio" }),
      };
    }

    await client.send(
      new DeleteCommand({
        TableName: TABLE,
        Key: { fileId },
      })
    );

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({ message: "Archivo eliminado", fileId }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ message: error.message }),
    };
  }
};
