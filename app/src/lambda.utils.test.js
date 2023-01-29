const lambdaUtils = require('./lambda.utils');

describe('GIVEN createHTTPOutput method', () => {
  describe('WHEN it is invoked with valid input', () => {
    test('THEN it should return valid output for empty parameters', () => {
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 202,
        body: null,
      };

      const actualOutput = lambdaUtils.createHTTPOutput();

      expect(actualOutput).toEqual(expectedOutput);
    });
    test('THEN it should return valid output for valid statusCode parameters', () => {
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 200,
        body: null,
      };

      const actualOutput = lambdaUtils.createHTTPOutput(200);

      expect(actualOutput).toEqual(expectedOutput);
    });
    test('THEN it should return valid output for valid object body parameters', () => {
      const expectedBody = { foo: 'bar', number: 1 };
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 200,
        body: expectedBody,
      };

      const actualOutput = lambdaUtils.createHTTPOutput(200, expectedBody);

      expect(actualOutput).toEqual(expectedOutput);
    });
    test('THEN it should return valid output for valid object body parameters', () => {
      const expectedBody = { foo: 'bar', number: 1 };
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 200,
        body: expectedBody,
      };

      const actualOutput = lambdaUtils.createHTTPOutput(200, expectedBody);

      expect(actualOutput).toEqual(expectedOutput);
    });
    test('THEN it should return valid output for valid string body parameters', () => {
      const expectedBody = 'random-text';
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 200,
        body: expectedBody,
      };

      const actualOutput = lambdaUtils.createHTTPOutput(200, expectedBody);

      expect(actualOutput).toEqual(expectedOutput);
    });
  });
  describe('WHEN it is invoked with invalid input', () => {
    test('THEN it should return valid output for invalid statusCode parameters', () => {
      const expectedOutput = {
        headers: {
          'Content-Type': 'application/json; charset=utf-16',
        },
        statusCode: 202,
        body: null,
      };

      const actualOutput = lambdaUtils.createHTTPOutput('random');

      expect(actualOutput).toEqual(expectedOutput);
    });
  });
});
