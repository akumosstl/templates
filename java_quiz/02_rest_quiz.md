# REST API Design -- Interview Quiz (Questions & Answers)

# What are the core principles of REST?

REST is based on: - Stateless communication - Client-server
architecture - Cacheability - Uniform interface - Layered system -
Optional code-on-demand

------------------------------------------------------------------------

# What is the difference between PUT and PATCH?

-   PUT replaces the entire resource.
-   PATCH partially updates a resource. PUT is idempotent. PATCH may or
    may not be idempotent depending on implementation.

------------------------------------------------------------------------

# What makes an API RESTful?

-   Uses HTTP methods correctly (GET, POST, PUT, DELETE)
-   Proper status codes
-   Resource-based URLs
-   Stateless requests
-   Proper content negotiation

------------------------------------------------------------------------

# How should resources be named in REST?

-   Use nouns, not verbs.
-   Use plural names.
-   Use hierarchical structure for relationships.

Example: /users /users/{id} /users/{id}/orders

------------------------------------------------------------------------

# What are idempotent HTTP methods?

GET, HEAD, OPTIONS, and TRACE are inherently idempotent because they are also "safe" methods, meaning they are intended for read-only operations and do not modify the server's state.<br>
PUT is idempotent because it replaces the target resource with the enclosed entity. Making the same PUT request multiple times will result in the resource having the same final state.<br>
DELETE is idempotent because a request to delete a resource multiple times has the same outcome as deleting it once: the resource is removed (though the first call might return a 200 OK and subsequent calls a 404 Not Found response, the final server state is the same).<br> 
Methods that are not idempotent are POST and PATCH (though PATCH can be made idempotent with specific implementation logic, such as using conditional requests or idempotency keys).<br>

------------------------------------------------------------------------

# What HTTP status codes are commonly used in REST APIs?

-   200 OK
-   201 Created
-   204 No Content
-   400 Bad Request
-   401 Unauthorized
-   403 Forbidden
-   404 Not Found
-   409 Conflict
-   500 Internal Server Error

------------------------------------------------------------------------

# How do you handle versioning in REST APIs?

Common approaches: - URI versioning (/v1/users) - Header versioning -
Content negotiation

URI versioning is the most common and explicit.

------------------------------------------------------------------------

# What is HATEOAS?

Hypermedia As The Engine Of Application State. The API provides links in
responses to guide clients through possible actions.

------------------------------------------------------------------------

# How should pagination be implemented?

Use query parameters: /users?page=0&size=20&sort=name,asc

Return metadata: - totalElements - totalPages - currentPage

------------------------------------------------------------------------

# How should errors be structured in a REST API?

Use consistent JSON structure:

{ "timestamp": "2026-02-13T15:00:00", "status": 400, "error": "Bad
Request", "message": "Invalid email format", "path": "/users" }

Consistency and clarity are key.
