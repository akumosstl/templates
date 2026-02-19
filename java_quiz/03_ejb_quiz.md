# EJBs

# What are the different EJB types and their state management characteristics?

Enterprise JavaBeans (EJB) provides three main bean types:<br>

Stateless Session Bean<br>

Stateful Session Bean<br>

Entity Bean (legacy – replaced by JPA entities in modern applications)<br>

***State Management:***<br>

Stateless Session Bean<br>

Does not maintain conversational state between method calls.<br>

Any instance variables are not preserved across client invocations.<br>

Instances are pooled and reused by the container.<br>

Best suited for independent, idempotent business operations.<br>

Stateful Session Bean<br>

Maintains conversational state between method calls.<br>

Preserves instance variables as long as the session is active.<br>

Associated with a specific client.<br>

Suitable for workflows or multi-step processes (e.g., shopping cart).<br>

# What is the difference between Stateless and Stateful Session Beans?


| Feature            | Stateless                 | Stateful                       |
| ------------------ | ------------------------- | ------------------------------ |
| State Preservation | No                        | Yes                            |
| Instance Pooling   | Yes                       | Limited                        |
| Client Association | No                        | Yes                            |
| Scalability        | High                      | Lower (due to client affinity) |
| Use Case           | Independent service calls | Conversational workflows       |



Key Difference:<br>

Stateless beans do not retain client-specific state.<br>

Stateful beans maintain state for a specific client session.<br>

Senior-Level Insight:<br>

In high-scale distributed systems, Stateless beans are generally preferred due to better scalability and simpler lifecycle management. Stateful beans introduce memory overhead and complexity in clustered environments.

# Which type of EJB is focused on data persistence?


Historically:<br>

Entity Beans were designed for data persistence.<br>

However:<br>

Entity Beans are deprecated in modern Java EE / Jakarta EE applications and replaced by:<br>

JPA (Java Persistence API) entities.<br>

Strong Interview Answer:<br>

In legacy EJB 2.x, Entity Beans handled persistence. In modern enterprise applications, JPA entities with @Entity and an EntityManager replace Entity Beans.<br>

# What are Declarative Transactions in EJB?


Declarative transactions are container-managed transactions configured using annotations such as:<br>

```java
@TransactionAttribute(TransactionAttributeType.REQUIRED)
```

The container automatically:<br>

Begins the transaction<br>

Commits on success<br>

Rolls back on runtime exception<br>

This avoids manual transaction handling.<br>

# Explain the TransactionAttribute types in EJB.

🔹 REQUIRED<br>

Uses existing transaction if present.<br>

Creates a new one if none exists.<br>

Default behavior.<br>

🔹 REQUIRES_NEW<br>

Suspends any existing transaction.<br>

Creates a completely new transaction.<br>

Independent commit/rollback.<br>

Important Use Case:<br>

Used when you need guaranteed persistence even if the outer transaction fails (e.g., audit logging).<br>

🔹 SUPPORTS<br>

Executes within a transaction if one exists.<br>

Executes without transaction if none exists.<br>

Does not create a new one.<br>

🔹 NOT_SUPPORTED<br>

Suspends existing transaction.<br>

Executes without transaction.<br>

Resumes original transaction after method ends.<br>

🔹 NEVER<br>

Method must not run inside a transaction.<br>

Throws exception if a transaction exists.<br>

🔹 MANDATORY<br>

Requires existing transaction.<br>

Throws exception if none exists.<br>

# How does REQUIRES_NEW work internally?


If the caller has an active transaction:<br>

The container suspends the caller’s transaction.<br>

A new transaction is started.<br>

The method executes.<br>

The new transaction is committed or rolled back.<br>

The original transaction is resumed.<br>

This guarantees isolation between transactional contexts.<br>

# When would you use REQUIRES_NEW instead of REQUIRED?


Use REQUIRES_NEW when:<br>

Logging audit records<br>

Sending notifications<br>

Persisting critical information that must commit independently<br>

Use REQUIRED when:<br>

You want business operations to participate in the same transactional boundary.<br>

# What are the risks of overusing Stateful beans?


Memory overhead<br>

Session replication complexity in clusters<br>

Scalability limitations<br>

Harder lifecycle management<br>

Modern distributed systems typically avoid them unless conversational state is truly required.<br>

# How does the EJB container manage transactions?


The container:<br>

Intercepts method calls via proxies<br>

Applies transaction rules<br>

Controls commit/rollback<br>

Manages suspension/resume<br>

Integrates with JTA (Java Transaction API)<br>

# What happens if a RuntimeException is thrown in a container-managed transaction?


The transaction is automatically marked for rollback.<br>

The container rolls back at method completion.<br>

Checked exceptions do not automatically trigger rollback unless explicitly configured.<br>