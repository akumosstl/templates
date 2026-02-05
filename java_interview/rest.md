# Rest

## 1. Difference between @Controller & @RestController?

The key difference between @Controller and @RestController in Spring lies in their intended use and how they handle the
response body.
@Controller:
Used in traditional Spring MVC applications where the controller's primary role is to prepare data and return a view (
e.g., an HTML page rendered by a templating engine like Thymeleaf or JSP).
If a method within a @Controller needs to return raw data (like JSON or XML) directly in the response body, it must be
explicitly annotated with @ResponseBody.
@RestController:
A specialized version of @Controller specifically designed for building RESTful web services.
It is a convenience annotation that combines the functionality of @Controller and @ResponseBody. This means that every
method within a class annotated with @RestController automatically serializes its return value into the response body (
typically as JSON or XML), eliminating the need to add @ResponseBody to each method.
@RestController is ideal for creating APIs that primarily serve data to client applications (e.g., single-page
applications, mobile apps) rather than rendering full web pages.
In summary, choose @Controller when you need to return views in a traditional MVC application, and use @RestController
when building REST APIs that primarily return raw data directly in the response body.

## 2. Explain the term ‘Statelessness’ with respect to RESTful WEB service & Enlist advantages and disadvantages of ‘Statelessness’.

Statelessness in RESTful Web Services
Statelessness is a core architectural constraint in REST (Representational State Transfer). It dictates that each
request from a client to a server must contain all the information necessary for the server to understand and process
the request, without relying on any stored context or session state on the server from previous requests. In essence,
the server should not store any client-specific data between requests.
This means:
No Server-Side Sessions: The server does not maintain session data or a "memory" of past interactions with a specific
client.
Self-Contained Requests: Every request from the client must include all required information, such as authentication
credentials, parameters, and any other data needed to fulfill the operation.
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

## 3. What are the best practices that are to be followed while designing RESTful web services?

Designing RESTful web services effectively requires adherence to several best practices to ensure maintainability,
scalability, and ease of use for consumers.
Resource-Based Design:
Use Nouns for Resources: URIs should represent resources (nouns) and not actions (verbs). For example, /users for a
collection of users and /users/123 for a specific user, instead of /getAllUsers.
Use Plural Nouns for Collections: Collections of resources should be named with plural nouns, like /products or /orders.
Hierarchical URIs for Relationships: Represent relationships between resources using nested URIs, such as
/customers/123/orders to retrieve orders for a specific customer.
HTTP Methods and Status Codes:
Utilize Standard HTTP Methods: Employ the appropriate HTTP verbs for CRUD operations:
GET for retrieving resources.
POST for creating new resources.
PUT for full updates of existing resources.
PATCH for partial updates of existing resources.
DELETE for removing resources.
Return Meaningful HTTP Status Codes: Provide informative status codes in responses to indicate the outcome of an
operation (e.g., 200 OK, 201 Created, 400 Bad Request, 404 Not Found, 500 Internal Server Error).
Statelessness and Caching:
Maintain Statelessness: Each request from a client to a server must contain all the information necessary to understand
the request. The server should not store any client context between requests.
Leverage Caching: Utilize HTTP caching mechanisms (e.g., Cache-Control headers) to improve performance and reduce server
load for frequently accessed, unchanging data.
Security and Performance:
Implement Security Measures: Use SSL/TLS for secure communication, implement authentication (e.g., OAuth 2.0, JWTs), and
authorize access to resources based on user roles and permissions.
Optimize for Performance: Employ techniques like pagination, filtering, and sorting to manage large datasets and allow
clients to request only the necessary information. Consider eager loading for related resources to reduce multiple
roundtrips.
Versioning and Documentation:
Version Your API: Implement a clear versioning strategy (e.g., /v1/users) to manage changes and ensure backward
compatibility.
Provide Comprehensive Documentation: Create detailed API documentation (e.g., using OpenAPI/Swagger) that clearly
describes endpoints, request/response formats, authentication, and error handling.
Error Handling:
Provide Informative Error Messages: Return clear and concise error messages, along with appropriate HTTP status codes,
to help clients understand and resolve issues. Avoid exposing sensitive server-side details in error responses.

## 4. What HTTP Status Code 200,201,204,304,400,401,404,409 & 500 states?

The HTTP status code 200, in English, means "OK".
This status code indicates that the client's request to the server was successful. The server has received, understood,
and processed the request without any issues, and the requested resource or content has been successfully delivered back
to the client.

HTTP status code 201 means Created.
This status code indicates that the request has been successfully fulfilled and, as a result, one or more new resources
have been created on the server. It is commonly used in response to POST or PUT requests when a new entity is created,
such as a new user account, a new blog post, or a new file.
The server typically includes a Location header in the response, pointing to the URI of the newly created resource,
allowing the client to access it directly.

The HTTP status code 204, known as "No Content," indicates that the server has successfully processed the client's
request but does not need to return any content in the response body.

HTTP Status Code 304, in plain English, means "Not Modified."
This status code indicates that the requested resource (like a webpage, image, or file) has not been changed on the
server since the last time the client (your browser) accessed it.

When your browser requests a resource, it might send a conditional request including headers like If-Modified-Since or
If-None-Match. If the server determines that the resource hasn't been updated since the date or ETag specified in these
headers, it responds with a 304 Not Modified status.
Instead of re-sending the entire resource, the server signals to your browser that it can use the version already stored
in its local cache, saving bandwidth and speeding up page load times.

The HTTP status code 400 translates to "Bad Request."
This code indicates that the server cannot or will not process the request due to an apparent client error. This means
the problem originates from the client (e.g., your web browser or application) rather than the server itself.

An HTTP 401 Unauthorized error means a request to access a resource has been denied because it lacks valid
authentication credentials, such as a username and password. The server understands the request but cannot authorize it,
and often the user must log in with correct credentials to proceed.

An HTTP 404 error means "Not Found," indicating the server could not find the requested web page, even though the server
itself is working. This usually happens when a user types a URL incorrectly, clicks a broken link, or tries to access a
page that has been moved or deleted. The error occurs on the client-side and signifies that the specific resource is
missing at that address.

The HTTP 409 status code, also known as "409 Conflict," indicates that a request made to the server could not be
completed because it conflicts with the current state of the target resource.
This means that while the request itself might be syntactically correct and the server understands it, some condition or
state on the server prevents the request from being processed successfully. This often occurs when:
Concurrent updates: Multiple users or processes attempt to modify the same resource simultaneously, leading to a
conflict in versions or changes. For example, two users editing the same document at the same time, and one tries to
save changes that are based on an older version of the document.
Duplicate resource creation: An attempt is made to create a resource that already exists and is not allowed to be
duplicated (e.g., creating a user account with an email address that is already registered).
Unmet conditions: The request includes conditions that are not met by the current state of the resource (e.g., trying to
update a resource with an If-Match header that doesn't match the current entity tag).
Business logic violations: The request violates specific rules or constraints defined by the application's logic (e.g.,
attempting a transaction with insufficient funds).
Essentially, the server is informing the client that the requested action cannot be performed in its current form due to
a conflict with the existing data or state on the server. The server should ideally provide more information in the
response body to help the client understand and resolve the conflict.

The HTTP status code 500, in English, means "Internal Server Error."
This is a generic error message indicating that the web server encountered an unexpected condition or a configuration
problem that prevented it from fulfilling the request made by the client (such as your web browser). It signifies that
something went wrong on the server's end, and it is unable to process the request and provide a valid response.
The 500 error is a broad category and does not specify the exact nature of the problem, which could be due to various
factors such as:
Server misconfigurations
Faulty scripts or programming errors
Database connection issues
Insufficient server resources
Permissions errors on files or folders
Corrupted .htaccess files
When you encounter an HTTP 500 error, it means the server itself is having a problem, rather than an issue with the
requested resource or a client-side error.

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

## 6. How you are doing API versioning in your application? What are the different approaches available for that with their benefits and   drawbacks?

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

## How can you make your Rest APIs secure?

Securing REST APIs involves implementing multiple layers of protection to safeguard data and prevent unauthorized access
or malicious activity.

**1. Authentication and Authorization**

**Authentication**: Verify the identity of the client accessing the API.

**API Keys**: Simple tokens for programmatic access.

**OAuth 2.0**: A robust framework for delegated authorization, often used with OpenID Connect for user authentication.

**JWT (JSON Web Tokens)**: Self-contained tokens that can carry user information and be signed to ensure authenticity.

**Authorization**: Determine what authenticated clients are permitted to do.

**Role-Based Access Control (RBAC)**: Assign permissions based on user roles.

**Attribute-Based Access Control (ABAC**): Grant access based on a combination of attributes (user, resource,
environment).

**2. Data Protection**

**HTTPS/TLS**: Encrypt all communication between client and server using Transport Layer Security (TLS) to prevent
eavesdropping and tampering. Ensure modern TLS versions (e.g., TLS 1.2 or 1.3) are used and outdated protocols are
disabled.

**Data Encryption at Rest**: Encrypt sensitive data when stored in databases or other storage systems.

**3. Input Validation and Sanitization**

Validate all incoming data to prevent injection attacks (SQL injection, XSS) and ensure data integrity.
Sanitize user input to remove potentially malicious characters or scripts.

**4. Rate Limiting and Throttling**

Implement mechanisms to limit the number of requests a client can make within a given timeframe to prevent brute-force
attacks and denial-of-service (DoS) attacks.

**5. Secure Coding Practices**

Follow secure coding guidelines to avoid common vulnerabilities like insecure direct object references (IDOR), broken
authentication, and security misconfigurations.
Regularly scan code for security vulnerabilities using static and dynamic analysis tools.

**6. Error Handling and Logging**

Implement proper error handling that avoids revealing sensitive information in error messages.
Maintain comprehensive logs of API activity for auditing and security monitoring.

**7. Security Headers**

Utilize HTTP security headers like Content Security Policy (CSP), X-Content-Type-Options, and X-Frame-Options to
mitigate various web vulnerabilities.

**8. API Gateway**

Consider using an API Gateway to centralize security policies, manage authentication and authorization, enforce rate
limits, and provide a single entry point for API access.

**9. Regular Security Audits and Penetration Testing**

Periodically conduct security audits and penetration tests to identify and address vulnerabilities in the API and its
underlying infrastructure.

## Which approach you are using to define contract documents of your APIs?

Defining API contracts for Java APIs is best achieved using a contract-first approach with a machine-readable
specification like OpenAPI (formerly Swagger). This method provides a clear, unambiguous, and shareable definition of
your API's interface.

9) What is @RestController?

10) What are the HTTP verbs?

11) What is the difference between POST and PUT?

12) Is it possible to fetch data using POST?

13) How to map a URI to a resource method?

14) What is a content-type?

15) How did you do authentication?

16) How to make a HTTPS URI?

17) Follow-up : What maps the URI to the method?

18) Difference between SOAP and REST

19) When to choose REST

20) What is the response code used indicate the successful processing of request.

21) What approach should be used while designing URI’s? Design one for GET/PUT/POST/DELETE.

22) How can you identify DDOS attack and what approach will you apply in order to handle the DDOS attack for your rest
    service?

To detect a DDoS attack underway before it’s too late, you need to know what normal network traffic looks like. By
creating a baseline of your usual traffic pattern, you can more easily identify the symptoms of a DDoS attack, such as
inexplicably slow network performance, spotty connectivity, intermittent web crashes, unusual traffic sources, or a
surge of spam.

API Gateway (rate limiter and throttling)
WAF - Web App Firewall
IP access control
Load balance and auto scaling
cloud
cdn

23) Basics of any of security concepts like OAuth 2 & JWT? 
