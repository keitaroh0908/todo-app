const { DynamoDBDocument } = require("@aws-sdk/lib-dynamodb");
const { DynamoDB } = require("@aws-sdk/client-dynamodb");

const docClient = DynamoDBDocument.from(new DynamoDB())

exports.handler = (event, context, callback) => {
    console.log(event.queryStringParameters)
    const taskId = event.queryStringParameters.taskId
    const params = {
        TableName: process.env.TABLE_NAME,
        Key: {
            userId: event.requestContext.authorizer.claims['cognito:username'],
            taskId: taskId
        }
    }

    docClient.delete(params, function(err, data) {
        if (err) {
            callback(Error(err))
        } else {
            const response = {
                statusCode: 200,
                headers: {
                    "Access-Control-Allow-Headers" : "*",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS"
                },
                body: JSON.stringify({
                    taskId: taskId
                })
            };
            callback(null, response)
        }
    })
}