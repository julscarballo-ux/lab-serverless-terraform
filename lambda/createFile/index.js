const { SQSClient, SendMessageCommand } = require("@aws-sdk/client-sqs");

const sqs = new SQSClient({});
const QUEUE_URL = process.env.QUEUE_URL;

const headers = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type,Authorization,x-api-key",
  "Content-Type": "application/json",
};

exports.handler = async (event) => {
  try {
    const body = JSON.parse(event.body || "{}");

    await sqs.send(
      new SendMessageCommand({
        QueueUrl: QUEUE_URL,
        MessageBody: JSON.stringify(body),
      })
    );

    return {
      statusCode: 200,
      headers,
      body: JSON.stringify({
        message: "Message queued",
      }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers,
      body: JSON.stringify({ message: error.message }),
    };
  }
};