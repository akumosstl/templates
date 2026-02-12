# Rest
REST and spring-boot.


# ‘Statelessness’ on RESTful WEB service (advantages and disadvantages)

Statelessness is a core architectural constraint in REST (Representational State Transfer).<br> 

It dictates that each request from a client to a server must contain all the information necessary for the server to understand and process the request, without relying on any stored context or session state on the server from previous requests. In essence, the server should not store any client-specific data between requests.<br>

***This means:***<br>
No Server-Side Sessions: The server does not maintain session data or a "memory" of past interactions with a specific client.<br>

***Self-Contained Requests:***<br>
Every request from the client must include all required information, such as authentication credentials, parameters, and any other data needed to fulfill the operation.<br>

Client Manages State: If any state needs to be maintained across requests (e.g., user login status), it is the client's
responsibility to manage and send that state information with each relevant request.
Advantages of Statelessness in RESTful Web Services
Scalability: Since the server doesn't need to store or manage client-specific state, it can handle a larger number of
concurrent requests and easily distribute requests across multiple servers in a load-balanced environment.
Reliability: Statelessness simplifies error recovery, as individual requests can be retried without concerns about an
inconsistent server state. If a server fails, another server can seamlessly take over without losing client context.
Visibility: Each request is self-descriptive, making it easier to monitor and debug the system, as all necessary
information for a request is contained within that single request.
Simplicity: The server-side implementation is simplified as it doesn't need to manage complex session management logic,
leading to cleaner and more maintainable code.
Cacheability: Responses to stateless requests can be more easily cached by intermediaries (proxies, CDNs) because
there's no dependency on server-side state, improving performance.

# RESTful best practices

Designing RESTful web services effectively requires adherence to several best practices to ensure maintainability, scalability, and ease of use for consumers.<br>

***Resource-Based Design:***<br>

**Use Nouns for Resources:** URIs should represent resources (nouns) and not actions (verbs). For example, /users for a collection of users and /users/123 for a specific user, instead of /getAllUsers.<br>

**Use Plural Nouns for Collections:** Collections of resources should be named with plural nouns, like /products or /orders.<br>

**Hierarchical URIs for Relationships:** Represent relationships between resources using nested URIs, such as /customers/123/orders to retrieve orders for a specific customer.<br>

**HTTP Methods and Status Codes:** <br>
Utilize Standard HTTP Methods: Employ the appropriate HTTP verbs for CRUD operations:<br>

GET for retrieving resources.<br>

POST for creating new resources.<br>

PUT for full updates of existing resources.<br>

PATCH for partial updates of existing resources.<br>

DELETE for removing resources.<br>

**Return Meaningful HTTP Status Codes:**<br>

Provide informative status codes in responses to indicate the outcome of an operation (e.g., 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Internal Server Error).<br>

***Statelessness and Caching:***<br>

**Maintain Statelessness:** <br>
Each request from a client to a server must contain all the information necessary to understand the request. The server should not store any client context between requests.<br>

**Leverage Caching:**
Utilize HTTP caching mechanisms (e.g., Cache-Control headers) to improve performance and reduce server load for frequently accessed, unchanging data.<br>

**Security and Performance:**<br>

**Implement Security Measures:**<br>
Use SSL/TLS for secure communication, implement authentication (e.g., OAuth 2.0, JWTs), and authorize access to resources based on user roles and permissions.<br>

**Optimize for Performance:**<br>
Employ techniques like pagination, filtering, and sorting to manage large datasets and allow clients to request only the necessary information. Consider eager loading for related resources to reduce multiple roundtrips.<br>

**Versioning and Documentation:**<br>

**Version Your API**: Implement a clear versioning strategy (e.g., /v1/users) to manage changes and ensure backward compatibility.<br>

**Provide Comprehensive Documentation:** Create detailed API documentation (e.g., using OpenAPI/Swagger) that clearly describes endpoints, request/response formats, authentication, and error handling.<br>

**Error Handling:**<br>

**Provide Informative Error Messages:** Return clear and concise error messages, along with appropriate HTTP status codes, to help clients understand and resolve issues. Avoid exposing sensitive server-side details in error responses.<br>

# HTTP Status Code 200,201,204,304,400,401,404,409 & 500

The HTTP status code 200, in English, means "OK".<br>
This status code indicates that the client's request to the server was successful. The server has received, understood, and processed the request without any issues, and the requested resource or content has been successfully delivered back to the client.<br>

HTTP status code 201 means Created.<br>
This status code indicates that the request has been successfully fulfilled and, as a result, one or more new resources have been created on the server. It is commonly used in response to POST or PUT requests when a new entity is created, such as a new user account, a new blog post, or a new file.<br>

The server typically includes a Location header in the response, pointing to the URI of the newly created resource, allowing the client to access it directly.<br>

The HTTP status code 204, known as "No Content," indicates that the server has successfully processed the client's request but does not need to return any content in the response body.<br>

HTTP Status Code 304, in plain English, means "Not Modified."<br>
This status code indicates that the requested resource (like a webpage, image, or file) has not been changed on the server since the last time the client (your browser) accessed it.<br>

When your browser requests a resource, it might send a conditional request including headers like If-Modified-Since or If-None-Match. If the server determines that the resource hasn't been updated since the date or ETag specified in these headers, it responds with a 304 Not Modified status.<br>

Instead of re-sending the entire resource, the server signals to your browser that it can use the version already stored in its local cache, saving bandwidth and speeding up page load times.<br>

The HTTP status code 400 translates to "Bad Request."<br>
This code indicates that the server cannot or will not process the request due to an apparent client error. This means the problem originates from the client (e.g., your web browser or application) rather than the server itself.<br>

An HTTP 401 Unauthorized error means a request to access a resource has been denied because it lacks valid authentication credentials, such as a username and password. The server understands the request but cannot authorize it, and often the user must log in with correct credentials to proceed.<br>

An HTTP 404 error means "Not Found," indicating the server could not find the requested web page, even though the server itself is working. This usually happens when a user types a URL incorrectly, clicks a broken link, or tries to access a page that has been moved or deleted. The error occurs on the client-side and signifies that the specific resource is missing at that address.<br>

The HTTP 409 status code, also known as "409 Conflict," indicates that a request made to the server could not be completed because it conflicts with the current state of the target resource.<br>

This means that while the request itself might be syntactically correct and the server understands it, some condition or state on the server prevents the request from being processed successfully. This often occurs when:<br>

Concurrent updates: Multiple users or processes attempt to modify the same resource simultaneously, leading to a conflict in versions or changes. For example, two users editing the same document at the same time, and one tries to save changes that are based on an older version of the document.<br>

Duplicate resource creation: An attempt is made to create a resource that already exists and is not allowed to be duplicated (e.g., creating a user account with an email address that is already registered).<br>

Unmet conditions: The request includes conditions that are not met by the current state of the resource (e.g., trying to update a resource with an If-Match header that doesn't match the current entity tag).<br>

Business logic violations: The request violates specific rules or constraints defined by the application's logic (e.g., attempting a transaction with insufficient funds).<br>

Essentially, the server is informing the client that the requested action cannot be performed in its current form due to a conflict with the existing data or state on the server. The server should ideally provide more information in the response body to help the client understand and resolve the conflict.<br>

The HTTP status code 500, in English, means "Internal Server Error."<br>
This is a generic error message indicating that the web server encountered an unexpected condition or a configuration problem that prevented it from fulfilling the request made by the client (such as your web browser). It signifies that something went wrong on the server's end, and it is unable to process the request and provide a valid response.<br>

The 500 error is a broad category and does not specify the exact nature of the problem, which could be due to various factors such as:<br>

Server misconfigurations<br>
Faulty scripts or programming errors<br>
Database connection issues<br>
Insufficient server resources<br>
Permissions errors on files or folders<br>
Corrupted .htaccess files<br>
When you encounter an HTTP 500 error, it means the server itself is having a problem, rather than an issue with the requested resource or a client-side error.<br>

## 5. Explain different HTTP methods like Get, PUT, POST, Delete, Patch, Head & Options?

HTTP methods, also known as HTTP verbs, define the type of action to be performed on a resource identified by a URL.
Here are explanations of the specified methods:
GET: This method is used to retrieve data from the server. It is a safe and idempotent method, meaning it does not alter
the server's state and multiple identical requests will have the same effect as a single one.
Código

    GET /users/123

This request would fetch the data for a user with ID 123.
POST: This method sends data to the server to create a new resource. It is not idempotent, meaning multiple identical
requests could result in the creation of multiple resources.
Código

    POST /users
    Content-Type: application/json

    {
        "name": "John Doe",
        "email": "john.doe@example.com"
    }

This request would create a new user resource.
PUT: This method is used to update or replace an existing resource with new data, or create it if it doesn't exist. It
is an idempotent method, meaning repeated identical requests will have the same effect as a single one.
Código

    PUT /users/123
    Content-Type: application/json

    {
        "name": "Jane Doe",
        "email": "jane.doe@example.com"
    }

This request would completely replace the data of the user with ID 123.
DELETE: This method is used to remove a specified resource from the server. It is an idempotent method.
Código

    DELETE /users/123

This request would delete the user resource with ID 123.
PATCH: This method is used to apply partial modifications to a resource. Unlike PUT, which requires sending the complete
resource, PATCH only needs to contain the changes to be applied. It is not an idempotent method.
Código

    PATCH /users/123
    Content-Type: application/json

    {
        "email": "new.email@example.com"
    }

This request would update only the email address of the user with ID 123.
HEAD: This method is almost identical to GET, but it retrieves only the header information of a resource without the
response body. It is useful for checking metadata like Content-Length or Content-Type without downloading the entire
resource.
Código

    HEAD /users

OPTIONS: This method describes the communication options for the target resource. It can be used to determine which HTTP
methods are supported by a particular URL.
Código

    OPTIONS /users

The response would typically include an Allow header listing the supported methods (e.g., Allow: GET, POST, PUT,
DELETE).

# API versioning

API versioning can be implemented using methods like URL path, query parameters, or request headers to manage API
changes without disrupting users. Each approach has trade-offs: URL versioning is clear and easy to see, query
parameters keep the URL clean but require clients to pass the parameter, and header versioning is the most hidden,
keeping the URL completely clean but making it less visible to users. The best method depends on factors like
scalability, usability, and project needs.

url versioning:
Version is included in the URL path, e.g., /api/v1/products

query parameter versioning
Version is passed as a parameter in the URL, e.g., /api/products?version=1.0.

header versioning
Version is specified in a custom request header, e.g., API-Version: 1.

media type versioning
Version is included in the Accept header as part of the media type, e.g., application/json;v=1.

# How can you make your Rest APIs secure?

Securing REST APIs involves implementing multiple layers of protection to safeguard data and prevent unauthorized access or malicious activity.<br>

**1. Authentication and Authorization**<br>

**Authentication**: Verify the identity of the client accessing the API.<br>

**API Keys**: Simple tokens for programmatic access.<br>

**OAuth 2.0**: A robust framework for delegated authorization, often used with OpenID Connect for user authentication.<br>

**JWT (JSON Web Tokens)**: Self-contained tokens that can carry user information and be signed to ensure authenticity.<br>

**Authorization**: Determine what authenticated clients are permitted to do.<br>

**Role-Based Access Control (RBAC)**: Assign permissions based on user roles.<br>

**Attribute-Based Access Control (ABAC**): Grant access based on a combination of attributes (user, resource, environment).<br>

**2. Data Protection**<br>

**HTTPS/TLS**: Encrypt all communication between client and server using Transport Layer Security (TLS) to prevent eavesdropping and tampering. Ensure modern TLS versions (e.g., TLS 1.2 or 1.3) are used and outdated protocols are disabled.<br>

**Data Encryption at Rest**: Encrypt sensitive data when stored in databases or other storage systems.<br>

**3. Input Validation and Sanitization**<br>

Validate all incoming data to prevent injection attacks (SQL injection, XSS) and ensure data integrity. Sanitize user input to remove potentially malicious characters or scripts.<br>

**4. Rate Limiting and Throttling**<br>

Implement mechanisms to limit the number of requests a client can make within a given timeframe to prevent brute-force attacks and denial-of-service (DoS) attacks.<br>

**5. Secure Coding Practices**<br>

Follow secure coding guidelines to avoid common vulnerabilities like insecure direct object references (IDOR), broken authentication, and security misconfigurations. Regularly scan code for security vulnerabilities using static and dynamic analysis tools.<br>

**6. Error Handling and Logging**<br>

Implement proper error handling that avoids revealing sensitive information in error messages. Maintain comprehensive logs of API activity for auditing and security monitoring.<br>

**7. Security Headers**<br>

Utilize HTTP security headers like Content Security Policy (CSP), X-Content-Type-Options, and X-Frame-Options to mitigate various web vulnerabilities.<br>

**8. API Gateway**<br>

Consider using an API Gateway to centralize security policies, manage authentication and authorization, enforce rate limits, and provide a single entry point for API access.<br>

**9. Regular Security Audits and Penetration Testing**<br>

Periodically conduct security audits and penetration tests to identify and address vulnerabilities in the API and its underlying infrastructure.<br>

# Contract documents

Defining API contracts for Java APIs is best achieved using a contract-first approach with a machine-readable specification like OpenAPI (formerly Swagger). This method provides a clear, unambiguous, and shareable definition of your API's interface.<br>

# Is it possible to fetch data using POST?

# What is a content-type?

# How did you do authentication?

# Difference between SOAP and REST

# How can you identify DDOS attack?

To detect a DDoS attack underway before it’s too late, you need to know what normal network traffic looks like. By creating a baseline of your usual traffic pattern, you can more easily identify the symptoms of a DDoS attack, such as inexplicably slow network performance, spotty connectivity, intermittent web crashes, unusual traffic sources, or a surge of spam.<br>

API Gateway (rate limiter and throttling)<br>
WAF - Web App Firewall<br>
IP access control<br>
Load balance and auto scaling<br>
cloud<br>
cdn<br>

