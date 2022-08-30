const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context, callback) => {
    const params = {
        TableName: process.env.TABLE_NAME,
        Key: {
            userId: event.requestContext.authorizer.claims['cognito:username'],
            taskId: event.pathParameters.taskId
        }
    }

    docClient.get(params, function(err, data) {
        if (err) {
            callback(Error(err))
        } else {
            callback(null, data.Items);
        }
    })
}
