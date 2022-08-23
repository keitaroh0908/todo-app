const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context, callback) => {
    const params = {
        TableName: process.env.TABLE_NAME,
        Key: {
            UserId: event.requestContext.authorizer.claims['cognito:username'],
            TaskId: event.body.taskId
        },
        UpdateExpression: 'SET Title = :title',
        ExpressionAttributeValues: {
            ":title": event.body.title
        }
    }

    docClient.update(params, function(err, data) {
        if (err) {
            callback(Error(err))
        } else {
            callback(null, data.Items);
        }
    })
}