const AWS = require('aws-sdk')
const docClient = new AWS.DynamoDB.DocumentClient()

exports.handler = (event, context, callback) => {
    const nowDateTime = new Date()
    const nowDateTimeISO8601 = nowDateTime.toISOString()

    const params = {
        TableName: process.env.TABLE_NAME,
        Item: {
            UserId: event.requestContext.authorizer.claims['cognito:username'],
            TaskId: generateUUID(),
            Title: event.body.title,
            IsCompletion: false,
            CreatedAt: nowDateTimeISO8601,
            UpdatedAt: nowDateTimeISO8601
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
