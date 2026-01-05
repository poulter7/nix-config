'use strict';

/**
 * Lambda@Edge function for HTTP Basic Authentication
 * Protects the CloudFront distribution with username/password
 */

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;
    const headers = request.headers;

    // Get credentials from environment variables (set by Terraform)
    // Terraform fetches these from Secrets Manager or variables during deployment
    const authUser = process.env.AUTH_USER;
    const authPass = process.env.AUTH_PASS;
    
    // Fail closed if credentials are not properly configured
    if (!authUser || !authPass) {
        console.error('Authentication misconfigured: AUTH_USER or AUTH_PASS not set');
        const response = {
            status: '503',
            statusDescription: 'Service Unavailable',
            body: 'Service temporarily unavailable',
            headers: {
                'content-type': [{
                    key: 'Content-Type',
                    value: 'text/plain; charset=UTF-8'
                }]
            }
        };
        callback(null, response);
        return;
    }
    
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
