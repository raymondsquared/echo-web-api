
const handler = async function lambdaHandler(event, context) {
  // console.log("event: \n" + JSON.stringify(event));
  // console.log("context: \n" + JSON.stringify(context));
  
  let responseBody = {
    input: {
      body: event.body,
    }
  };

  let output = {
    headers: { 'Content-Type': 'application/json; charset=utf-8' },
    statusCode: 200,
    body: JSON.stringify(responseBody)
  };

  console.log({ output });
  return output;
};

exports.handler = handler;
