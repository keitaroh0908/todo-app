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
            callback(null, data.Items);
        }
    })
}
