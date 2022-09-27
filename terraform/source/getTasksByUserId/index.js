const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context, callback) => {
    const params = {
        TableName: process.env.TABLE_NAME,
        KeyConditionExpression: 'userId = :userId',
        ExpressionAttributeValues: {
            ':userId': event.requestContext.authorizer.claims['cognito:username']
        }
    }

    docClient.query(params, function(err, data) {
        if (err) {
            callback(Error(err))
        } else {
            const response = {
                statusCode: 200,
                headers: {
                    "Access-Control-Allow-Headers" : "*",
                    "Access-Control-Allow-Origin": "*",
                    "Access-Control-Allow-Methods": "*",
                    "Access-Control-Expose-Headers": "*"
                },
                body: JSON.stringify(data.Items)
            };
            callback(null, response);
        }
    })
}
