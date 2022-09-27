const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context, callback) => {
    const now = new Date().toISOString()

    const params = {
        TableName: process.env.TABLE_NAME,
        Item: {
            userId: event.requestContext.authorizer.claims['cognito:username'],
            taskId: generateUUID(),
            title: event.body.title,
            createdAt: now
        }
    }

    docClient.put(params, function(err, data) {
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

function generateUUID() {
    let uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.split('')

    for (let index = 0, length = uuid.length; index < length; index++) {
        switch (uuid[index]) {
            case 'x':
                uuid[index] = Math.floor(Math.random() * 16).toString(16)
                break
            case 'y':
                uuid[index] = (Math.floor(Math.random() * 4) + 8).toString(16)
                break
        }
    }

    return uuid.join('')
}
