const aws = require('aws-sdk');
const httpStatus = require('http-status');
const utils = require('./lambda.utils');

const documentClient = new aws.DynamoDB.DocumentClient();

const handler = async function lambdaHandler(event, context) {
  console.log(`event: \n${JSON.stringify(event)}`);
  console.log(`context: \n${JSON.stringify(context)}`);

  let output = utils.createHTTPOutput();

  // Check if API key exists if the requests come from API Gateway
  const defaultAPIKey = process.env.API_KEY;
  const whitelistAPIkeys = [
    defaultAPIKey,
  ];

  // Validation
  if (event?.headers && !whitelistAPIkeys?.includes(event?.headers['x-api-key'])) {
    console.log('Invalid API key was provided');
    output = utils.createHTTPOutput(
      httpStatus.UNAUTHORIZED,
      {
        error: {
          code: 'RR-4011',
          message: 'Error: Invalid API key was provided',
        },
      },
    );
    console.log({ output });
    return output;
  }

  const apiKeyHeader = event?.headers ? event?.headers['x-api-key'] : defaultAPIKey;
  console.log({ apiKeyHeader });

  let postBody = event?.body ? event?.body : event;
  let isPostBodyJSON = false;
  try {
    postBody = JSON.parse(event?.body);
    isPostBodyJSON = true;
  } catch (error) {
    console.log('postBody is not a valid JSON object');
  }

  let responseStatusCode = httpStatus.OK;
  let responseBody = {
    data: {
      body: isPostBodyJSON ? JSON.parse(event?.body) : event?.body,
    },
  };

  const tableName = 'echo-web-api-table';
  const httpMethod = event?.httpMethod?.toUpperCase() || 'GET';

  switch (httpMethod) {
    case 'GET':
      console.log('Processing GET request...');

      try {
        const getInput = {
          TableName: tableName,
          Key: {
            key: apiKeyHeader,
          },
        };

        const dynamoDBGetOutput = await documentClient.get(getInput).promise();
        console.log({ dynamoDBGetOutput });

        responseBody = {
          input: {
            body: dynamoDBGetOutput?.Item?.value,
          },
        };
      } catch (error) {
        responseStatusCode = httpStatus.INTERNAL_SERVER_ERROR;
        responseBody = {
          error: {
            code: 'RR-5001',
            message: error?.message,
          },
        };
      }

      break;
    case 'POST':
    case 'PUT':
    case 'PATCH':
    case 'DELETE':
      console.log('Writting to db...');

      try {
        let value = postBody;
        if (isPostBodyJSON) value = { ...postBody };

        const putInput = {
          TableName: tableName,
          Item: {
            key: apiKeyHeader,
            value,
            dateTime: new Date()?.toISOString(),
          },
        };

        const dynamoDBPutOutput = await documentClient.put(putInput).promise();
        console.log({ dynamoDBPutOutput });

        responseStatusCode = httpStatus.CREATED;
      } catch (error) {
        responseStatusCode = httpStatus.INTERNAL_SERVER_ERROR;
        responseBody = {
          error: {
            code: 'RR-5002',
            message: error?.message,
          },
        };
      }

      break;
    default:
      console.log(`Unknown HTTP method ${httpMethod}`);
      responseStatusCode = httpStatus.NOT_IMPLEMENTED;
      responseBody = {
        error: {
          code: 'RR-5011',
          message: 'Unknown HTTP method',
        },
      };
      break;
  }

  output.statusCode = responseStatusCode;
  output.body = JSON.stringify(responseBody);

  console.log({ output });
  return output;
};

exports.handler = handler;
