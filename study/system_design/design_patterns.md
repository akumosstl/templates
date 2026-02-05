### Strangler

Miggrating from monolithig to microservices

### Hexagonal

Before: Tree tier layers archicteture

- presentation
- logic
- data

coupling x testing , the problem

Hexagonal

{code} -> interact like apis -> {contract} or {port}

adapter

### Onion architecture

- domain entities
- repository
- services
- infra
- ui

4 tenents of onion

- all application core code can be compiled and run separate from infrastructure
- inner layers define interfaces outer layers implement it
- direction of couple is toward the center
- the app is built arround an independent object model

### Sidecar pattern

main service x helper component
no business logic tasks (ex log, monitoring, service discovery)

### RESTful APIS

- resources (/order)
- http methods
- statelessness
- uniform interface (json)
- cacheability
- idempotent

### Retry pattern

### Reactive programming

### Rate limiter

### Kafka

- event stream platform
    - could be used either as message queue or stream processing system

### Clean architecture