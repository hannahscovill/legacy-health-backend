import { APIGatewayProxyEvent, Context } from 'aws-lambda';
import { lambdaHandler } from '../src/index'

const legacyContext: Context = {
    callbackWaitsForEmptyEventLoop: false,
    functionName: "my-lambda-function",
    functionVersion: "$LATEST",
    invokedFunctionArn: "arn:aws:lambda:REGION:ACCOUNT_ID:function:my-lambda-function",
    memoryLimitInMB: "128",
    awsRequestId: "a1b2c3d4-e5f6-7890-1234-567890abcdef",
    logGroupName: "/aws/lambda/my-lambda-function",
    logStreamName: "2025/08/07/[LATEST]a1b2c3d4e5f678901234567890abcdef",
    getRemainingTimeInMillis: () => 30000,
    done: () => { },
    fail: () => { },
    succeed: () => { },
    identity: {
        cognitoIdentityId: "us-east-1:xxxxxx",
        cognitoIdentityPoolId: "us-east-1:yyyyyy"
    },
    clientContext: {
        client: {
            installationId: "some_id",
            appTitle: "my_app",
            appVersionName: "1.0",
            appVersionCode: "1",
            appPackageName: "com.example.myapp"
        },
        env: {
            platformVersion: "14.0",
            platform: "IOS",
            make: "Apple",
            model: "iPhone",
            locale: "en_US"
        },
        Custom: {
            some_custom_key: "some_custom_value"
        }
    }
}

const legacyEvent: APIGatewayProxyEvent = {
    resource: "/",
    path: "/",
    httpMethod: "GET",
    headers: {
        accept: "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
        "accept-encoding": "gzip, deflate, br",
        Host: "70ixmpl4fl.execute-api.us-east-2.amazonaws.com",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36",
        "X-Amzn-Trace-Id": "Root=1-5e66d96f-7491f09xmpl79d18acf3d050"
    },
    multiValueHeaders: {
        accept: [
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9"
        ],
        "accept-encoding": [
            "gzip, deflate, br"
        ]
    },
    queryStringParameters: null,
    multiValueQueryStringParameters: null,
    pathParameters: null,
    stageVariables: null,
    requestContext: {
        accountId: "123456789012",
        apiId: "70ixmpl4fl",
        protocol: "HTTP/1.1",
        httpMethod: "GET",
        path: "/Prod/",
        stage: "Prod",
        requestId: "c6af9ac6-7b61-11e6-9a41-93e8deadbeef",
        requestTime: "25/Jul/2016:12:34:56 +0000",
        requestTimeEpoch: 1469447696000,
        resourceId: "123456",
        resourcePath: "/",
        identity: {
            accessKey: null,
            accountId: null,
            apiKey: null,
            apiKeyId: null,
            caller: null,
            cognitoAuthenticationProvider: null,
            cognitoAuthenticationType: null,
            cognitoIdentityId: null,
            cognitoIdentityPoolId: null,
            principalOrgId: null,
            sourceIp: "203.0.113.11",
            user: null,
            userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.132 Safari/537.36",
            userArn: null,
            clientCert: null
        },
        authorizer: null
    },
    body: null,
    isBase64Encoded: false
}


console.log(
    lambdaHandler(legacyEvent, legacyContext, () => { })
)