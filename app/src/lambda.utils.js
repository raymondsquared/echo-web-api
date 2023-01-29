const httpStatus = require('http-status');

const createHTTPOutput = function createLambdaHTTPOutputForAPIGateway(
  statusCode = httpStatus.ACCEPTED,
  body = null,
) {
  let httpStatusCode = httpStatus.ACCEPTED;
  let bodyString = '';

  // TO DO: need to do a proper HTTP status code check here
  if (Number.isInteger(statusCode)) httpStatusCode = statusCode;

  try {
    bodyString = JSON.stringify(body);
  } catch (error) {
    bodyString = body;
  }

  return {
    headers: {
      'Content-Type': 'application/json; charset=utf-16',
    },
    statusCode: httpStatusCode,
    body: bodyString,
  };
};

module.exports = {
  createHTTPOutput,
};
