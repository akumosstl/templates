# Resilience layer

In Spring Boot, a resilience layer refers to the implementation of strategies and patterns within an application to
enable it to handle and recover gracefully from failures, unexpected disruptions, and varying loads, particularly in
distributed environments like microservices architectures. The goal is to ensure the system remains available,
responsive, and performs consistently even when individual components or external dependencies experience issues.

Key concepts and patterns commonly found in a Spring Boot resilience layer include:

**Circuit Breaker**: Prevents cascading failures by stopping calls to a failing service after a certain threshold of
errors is met. It can then allow limited calls after a timeout to check if the service has recovered.

Example

```java
// Example Service
@Service
public class MyService {

    @HystrixCommand(fallbackMethod = "getFallbackData", commandProperties = {
            @HystrixProperty(name = "circuitBreaker.errorThresholdPercentage", value = "50") // Trip if 50% errors
    })
    public String callRemoteService() {
        // Simulate failure by throwing an exception
        if (Math.random() > 0.6) {
            throw new RuntimeException("Service Unavailable!");
        }
        return "Success from remote service!";
    }

    // Fallback Method
    public String getFallbackData() {
        return "Fallback data: Service is temporarily down, using cached/default data.";
    }
}

```

**How it Works**

**Closed State**: Requests flow to the service. Hystrix monitors success/failure rates.

**Open State**: If failures exceed the errorThresholdPercentage (e.g., 50%), the circuit "trips" open. All calls
immediately return the fallback response without hitting the service for a set duration.

**Half-Open State**: After the timeout, Hystrix allows a few test requests through. If they succeed, the circuit closes;
if they fail, it reopens.

**Fallback**: The getFallbackData() method provides a graceful response when the circuit is open, preventing resource
exhaustion and cascading failures.

#### Key Hystrix Properties

circuitBreaker.errorThresholdPercentage: Triggers the open state.
circuitBreaker.requestVolumeThreshold: Minimum requests before monitoring starts.
circuitBreaker.sleepWindowInMilliseconds: Time in the open state before moving to half-open.

```yml
hystrix:
  command:
    default:
      circuitBreaker:
        requestVolumeThreshold: 3
        errorThresholdPercentage: 70
        sleepWindowInMilliseconds: 3000
      metrics:
        rollingStats:
          timeInMilliseconds: 5000
```

**Retry**: Automatically re-attempts failed operations a specified number of times, often with a backoff strategy (e.g.,
exponential backoff) to avoid overwhelming the failing service.

**Bulkhead**: Isolates resources (e.g., thread pools, connections) for different services or components, preventing a
failure in one area from consuming all resources and affecting others.

**Rate Limiter**: Controls the rate at which requests are made to a service or resource, preventing overload and
ensuring fair access.

**Time Limiter**: Enforces a timeout for operations, preventing long-running or unresponsive calls from blocking the
system.

**Fallbacks**: Provides alternative execution paths or default values when an operation fails, ensuring a degraded but
still functional experience for the user.

Libraries like Resilience4j are commonly used in Spring Boot to implement these resilience patterns declaratively using
annotations. This allows developers to easily apply resilience strategies to their methods and services without writing
extensive boilerplate code.