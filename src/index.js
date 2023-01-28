const aws = require('aws-sdk');
const documentClient = new aws.DynamoDB.DocumentClient();

const handler = async function lambdaHandler(event, context) {
  console.log("event: \n" + JSON.stringify(event));
  // console.log("context: \n" + JSON.stringify(context));

  let output = {
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
    statusCode: 200,
    body: null,
  };

  // Check if API key exists if the requests come from API Gateway
  const apiKey = process.env.API_KEY;
  if (event.headers && event.headers['x-api-key'] != process.env.API_KEY) {
    output.statusCode = 401;
    output.body = JSON.stringify({
      error: {
        code: 'RR-401',
        message: 'Error: Invalid API key was provided',
      },
    });

    return output;
  }

  let responseBody = {
    input: {
      body: event.body,
    }
  };

  const tableName = 'echo-web-api-table';
  const httpMethod = event?.httpMethod?.toUpperCase() || 'GET';
  switch (httpMethod) {
    case 'GET':
      console.log("Processing GET request...");
      const getInput = {
        TableName: tableName,
        Key: {
          'key': apiKey,
        }
      };

      const dynamoDBGetOutput = await documentClient.get(getInput).promise();
      // console.log({ dynamoDBGetOutput });

      responseBody = {
        input: {
          body: dynamoDBGetOutput?.Item?.value,
        },
      };
      break;
    case 'POST':
    case 'PUT':
    case 'PATCH':
    case 'DELETE':
      console.log("Writting to db...");

      const postBody = JSON.parse(event?.body);
      console.log({ postBody });

      const putInput = {
        TableName: tableName,
        Item: {
          key: apiKey,
          value: {
            ...postBody,
          },
          dateTime: new Date().toISOString(),
        },
      };

      const dynamoDBPutOutput = await documentClient.put(putInput).promise();
      // console.log({ dynamoDBPutOutput });

      break;
    default:
      console.log(`Unknown HTTP method ${httpMethod}`);
      break;
  };

  output.body = JSON.stringify(responseBody);

  console.log({ output });
  return output;
};

exports.handler = handler;
