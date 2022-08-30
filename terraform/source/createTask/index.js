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
            isCompletion: false,
            createdAt: now,
            updatedAt: now
        }
    }

    docClient.put(params, function(err, data) {
        if (err) {
            callback(Error(err))
        } else {
            callback(null, data.Items);
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
