const { DynamoDBDocument } = require('@aws-sdk/lib-dynamodb');
const { DynamoDB } = require('@aws-sdk/client-dynamodb');

const docClient = DynamoDBDocument.from(new DynamoDB())

exports.handler = (event, context, callback) => {
    const now = new Date().toISOString()
    const body = JSON.parse(event.body)

    const item = {
        userId: event.requestContext.authorizer.claims['cognito:username'],
        taskId: generateUUID(),
        title: body.title,
        createdAt: now
    }

    const params = {
        TableName: process.env.TABLE_NAME,
        Item: item
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
                    "Access-Control-Allow-Methods": "GET,POST,DELETE,OPTIONS"
                },
                body: JSON.stringify(item)
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
