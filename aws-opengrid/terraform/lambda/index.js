'use strict';

/**
 * Lambda@Edge function for HTTP Basic Authentication
 * Protects the CloudFront distribution with username/password
 */

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;

    // Get credentials from environment or use defaults (should be set via Terraform)
    // In production, these should come from AWS Secrets Manager or similar
    const authUser = process.env.AUTH_USER || 'admin';
    const authPass = process.env.AUTH_PASS || 'changeme';
    
    // Create the expected Authorization header value
    const authString = 'Basic ' + Buffer.from(authUser + ':' + authPass).toString('base64');

    // Check if Authorization header exists and matches
    if (typeof headers.authorization === 'undefined' || 
        headers.authorization.length === 0 || 
        headers.authorization[0].value !== authString) {
        // Authentication failed - return 401 response
        const response = {
            status: '401',
            statusDescription: 'Unauthorized',
            body: 'Authentication required',
            headers: {
                'www-authenticate': [{
                    key: 'WWW-Authenticate',
                    value: 'Basic realm="OpenGrid", charset="UTF-8"'
                }],
                'content-type': [{
                    key: 'Content-Type',
                    value: 'text/plain; charset=UTF-8'
                }]
            }
        };
        callback(null, response);
        return;
    }

    // Authentication successful - continue to origin
    callback(null, request);
};
