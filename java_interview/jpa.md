# JPA & Hibernate

## Table of contents

### 1. [Hibernate advantages](#hibernate-advantages)

### 2. [SessionFactory and Session](#sessionfactory-and-session)

### 3. [Cache](#cache)

### 4. [Methods](#methods)

### 5. [HQL, Named SQL Query and Criteria Query](#hql-named-sql-query-and-criteria-query)

## Hibernate advantages

Hibernate offers several advantages over raw JDBC for interacting with databases in Java applications:

**Object-Relational Mapping (ORM)**

Hibernate automates the mapping between Java objects and database tables, eliminating the need for manual SQL query
writing and result set parsing. This significantly reduces boilerplate code and development time.

**Database Independence**

Hibernate's HQL (Hibernate Query Language) and Criteria API are database-independent, allowing applications to switch
between different database systems with minimal code changes. JDBC, in contrast, requires database-specific SQL queries.

**Reduced Boilerplate Code**

Hibernate handles connection management, transaction management, and resource closing automatically, freeing developers
from writing repetitive JDBC code.

**Caching Mechanisms**

Hibernate includes built-in caching (first-level and second-level) to reduce database roundtrips and improve application
performance. JDBC does not offer such built-in caching.

**Lazy Loading**

Hibernate supports lazy loading, where related objects are only loaded from the database when they are actually
accessed, optimizing resource usage and performance.

**Simplified Exception Handling**

Hibernate converts checked SQLExceptions into unchecked RuntimeExceptions, simplifying error handling and reducing the
need for extensive try-catch blocks.

**Support for Object-Oriented Concepts**

Hibernate seamlessly supports object-oriented features like inheritance, polymorphism, and associations (one-to-one,
one-to-many, many-to-one, many-to-many), making database interactions more natural for Java developers.

**Improved Maintainability and Scalability**

The higher level of abstraction and reduced code complexity offered by Hibernate generally leads to more maintainable
and scalable applications compared to those built with raw JDBC.

## SessionFactory and Session

a. What are SessionFactory and Session? Are SessionFactory and Session thread safe?
b. Does it Session the same as the PersistentContext?
c. Why and when do we need detached an entity?
d. What it is dirty check?
e. Are Session the same as the PersistentContext?

In Hibernate, the thread safety of SessionFactory and Session objects differs significantly.

**SessionFactory**

**Thread-Safe**: The SessionFactory is designed to be thread-safe. It is a heavyweight object, typically created once
per application during startup and shared across all threads.

**Purpose**: Its primary role is to create Session instances, manage database connection pooling, handle caching
strategies (like the second-level cache), and store metadata about entity mappings. Since it's thread-safe, multiple
threads can concurrently request new Session objects from the same SessionFactory instance without issues.

**Session**

**Not Thread-Safe**: The Session object is not thread-safe. Each Session instance should be used by only one thread at a
time.

**Purpose**: A Session represents a single unit of work with the database. It establishes a physical connection, manages
the first-level cache, and tracks the state of persistent objects within its scope.

**Concurrency Issues**: Sharing a Session across multiple threads can lead to race conditions, inconsistent data, and
other unpredictable behavior, as methods within the Session are not synchronized for concurrent access.

**In summary**
Use a single SessionFactory instance per application (or per database if using multiple) and share it across all
threads.
Create a new Session instance for each unit of work or for each thread that needs to interact with the database. Do not
share Session objects between threads. This is often achieved using patterns like "session-per-request" in web
applications or "session-per-thread" in other multi-threaded environments.

**Why and when do we need detached an entity?**

Detaching an entity in JPA and Hibernate means removing it from the persistence context, transitioning it from a "
managed" state to a "detached" state.

While a managed entity's changes are automatically tracked and synchronized with the database by the EntityManager, a
detached entity is no longer under its management, and its modifications will not be persisted unless it is reattached.

**Why detach an entity?**

Performance Optimization for Long-Running Transactions or Units of Work: In scenarios involving long-running processes
or user interaction (e.g., a multi-step form), keeping entities managed throughout can lead to excessive memory
consumption and potential transactional issues. Detaching entities allows them to exist outside the persistence context,
reducing the overhead and enabling the EntityManager to be closed and reopened as needed.

Minimizing Transactional Locks: By detaching entities, you can reduce the time a database transaction remains open,
thereby minimizing the potential for locking issues and improving concurrency.

Transferring Entities Between Persistence Contexts: Detached entities can be easily transferred between different
EntityManager instances or even across different application tiers (e.g., from a service layer to a presentation layer)
without carrying the burden of an active persistence context.

Handling Large Data Sets: When processing a large number of entities, detaching them after they have been processed can
help manage memory usage and prevent out-of-memory errors by allowing the garbage collector to reclaim memory.

Specific Update/Delete Operations: When performing bulk updates or deletes using JPQL or native SQL, Hibernate might not
be aware of the changes made to the underlying database records. Detaching relevant entities before executing such
operations ensures data consistency by preventing outdated managed entities from being present in the persistence
context.

**When to detach an entity?**

After Completing a Transaction: Once a unit of work is finished and the changes are flushed and committed to the
database, entities that are no longer needed within the current persistence context can be detached.
Before Long-Running Operations: If an entity needs to be held for an extended period, especially across user think-time
or multiple application layers, detaching it avoids keeping the EntityManager open unnecessarily.
When Passing Entities to Different Layers: When passing entity objects from a data access layer to a service layer or a
presentation layer, detaching them ensures that the consuming layer is not implicitly tied to the persistence context.
Before Bulk Updates/Deletes: If you are performing a bulk update or delete operation using JPQL or native SQL that might
affect entities currently managed by the EntityManager, detaching those entities is recommended to avoid
inconsistencies.
How to detach an entity:
You can explicitly detach a single entity using EntityManager.detach(entity) or clear the entire persistence context,
effectively detaching all managed entities, using EntityManager.clear().

```Java

// Detach a specific entity
entityManager.detach(myEntity);

// Detach all entities in the persistence context
entityManager.

clear();
```

**Are Session the same as the PersistentContext?**

No, a persistence context is not exactly the same as a session, but they are deeply related: the Persistence Context is
the in-memory cache (like Hibernate's first-level cache) that tracks managed entities, while the Session (or
EntityManager in JPA) is the API or handle that manages that context, providing methods (get, save, persist, etc.) to
interact with it and the database, often spanning a transaction. The session/EntityManager controls the persistence
context; the context holds the entities and detects changes, flushing them to the database when the session/transaction
ends.
Persistence Context (The Cache)
What it is: A first-level cache where Hibernate/JPA keeps track of loaded entity instances (e.g., Student objects).
Key Feature: Ensures only one instance per database row, manages entity states (transient, persistent, detached), and
performs automatic dirty checking.
Lifecycle: Lives within a session, often tied to a transaction.
Session / EntityManager (The API)
What it is: The interface (Hibernate Session, JPA EntityManager) you use to talk to the database.
Key Feature: Provides methods to load, save, update, and delete entities, interacting with the persistence context.
Lifecycle: Opened and closed by the application or container, defining the boundary for the persistence context.
Analogy
Think of the Session/EntityManager as your banker, and the Persistence Context as the vault (cache) where the banker
keeps track of the specific cash (entities) you've requested or deposited during your visit (transaction). The banker (
Session) gives you the keys (methods) to access the vault (Context), and when you leave (session/transaction closes),
the banker finalizes all changes in the vault and sends them to the main bank (database).

**What it is dirty check?**

JPA's dirty checking mechanism, primarily implemented by providers like Hibernate, automatically detects changes made to
managed entities within a transaction and synchronizes those changes with the database. This eliminates the need for
explicit update() or save() calls for modifications to existing entities.
Here's how it works:
Entity State Tracking (Snapshotting): When an entity is loaded from the database or persisted into the persistence
context, JPA (or Hibernate) creates a snapshot of its initial state (the values of its fields) and stores it in memory
within the persistence context.
Change Detection: During the course of a transaction, if you modify the fields of a managed entity in your Java code,
JPA keeps track of these changes.
Flush Time Comparison: At certain points, known as "flush time," JPA compares the current state of the entity in memory
with the snapshot taken at the beginning. Flush events can occur automatically before a transaction commit, before
executing a query that might need up-to-date data, or when explicitly requested by the developer (e.g., using
EntityManager.flush()).
Dirty Entity Identification: If the comparison reveals any differences between the current state and the snapshot, the
entity is marked as "dirty."
SQL Generation and Execution: For each "dirty" entity, JPA automatically generates the necessary UPDATE SQL statements
to synchronize the changes with the database. Importantly, it typically generates UPDATE statements that only target the
modified columns, optimizing performance.
Database Synchronization: The generated UPDATE statements are then executed against the database, persisting the
changes.
Key aspects:
Managed Entities Only: Dirty checking only applies to entities that are in a "managed" state within the persistence
context (e.g., loaded from the database or newly persisted). Detached entities are not subject to dirty checking.
Automatic Updates: Developers do not need to explicitly call save() or update() methods for entities that are already
managed and have been modified.
Performance Optimization: By only updating modified columns, dirty checking can improve performance compared to updating
all columns of an entity.
Transactional Context: Dirty checking operates within the scope of a transaction, ensuring atomicity and consistency of
data.

Read-Only Transaction
When a transaction is marked as read-only with @Transactional(readOnly = true), Hibernate optimizes performance by
skipping entity snapshots. Since no snapshots are created, Hibernate cannot detect modifications. When the managed
entity is modified, those changes are ignored if not persisted manually.

In general, @Transactional(readOnly=true) doesn’t enforce read-only behavior at the database level, it only prevents
Hibernate from taking snapshots, tracking modifications and automatically flushing the session. Changes will be applied
if an explicit save() or persist() is called.

Interaction With @Immutable Entities
Entities annotated with @Immutable are treated as read-only by Hibernate. Since they’re considered unchangeable,
Hibernate skips tracking modifications, preventing dirty checking. Even if a property of the entity is modified,
Hibernate won’t track the change, and no updates will be submitted to the database.

## Cache

a. What is hibernate caching? Explain Hibernate first level cache?
b. How to configure second level caching?
c. What is query level cache?

**Hibernate Caching**
Hibernate caching is a mechanism used to store frequently accessed data in memory, reducing the number of database
queries and improving application performance. It aims to minimize the latency associated with database interactions by
serving data from a faster in-memory store whenever possible.

**Hibernate First-Level Cache**
The Hibernate first-level cache, also known as the session cache or persistence context, is a mandatory, built-in cache
associated with each individual Session object. It operates at the session level, meaning each Session maintains its own
independent first-level cache.

**Scope**: Local to a single Session.

**Mechanism**: When an entity is loaded or persisted within a Session, it is stored in this cache. Subsequent requests
for the same entity within that same Session will retrieve it directly from the first-level cache, avoiding a database
hit.

**Lifespan**: The cache is cleared when the Session is closed.

**Default Behavior**: It is always enabled and cannot be disabled.

**Configuring Second-Level Caching**
The second-level cache is an optional, application-wide cache shared across all Session objects created by a
SessionFactory. It requires explicit configuration and the use of a third-party cache provider (e.g., Ehcache,
Infinispan, Hazelcast).

**Steps to configure second-level caching**

Add Cache Provider Dependency: Include the necessary dependency for your chosen cache provider in your project's build
file (e.g., pom.xml for Maven).

```xml

<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-ehcache</artifactId>
    <version>6.x.x</version> <!-- Use appropriate version -->
</dependency>
<dependency>
<groupId>net.sf.ehcache</groupId>
<artifactId>ehcache</artifactId>
<version>2.10.x</version> <!-- Use appropriate version -->
</dependency>
```

Enable Second-Level Cache in Hibernate Configuration: In your hibernate.cfg.xml or Spring configuration, enable the
second-level cache and specify the cache provider.

```xml

<property name="hibernate.cache.use_second_level_cache">true</property>
<property name="hibernate.cache.region.factory_class">org.hibernate.cache.ehcache.EhCacheRegionFactory</property>
```

Annotate Entities for Caching: Mark the entities or collections you want to cache with @Cacheable and specify the cache
concurrency strategy.

```Java

@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MyEntity {
    // ...
}
```

Configure Cache Provider (if necessary): Create a configuration file for your chosen cache provider (e.g., ehcache.xml)
to define cache regions, eviction policies, and other settings.

**Query-Level Cache**
The query cache is a specialized part of the second-level cache that stores the result sets of frequently executed
queries, not individual entities.

Mechanism: When a query is executed with caching enabled, Hibernate stores the IDs of the entities returned by that
query, along with the query parameters. Subsequent executions of the same query with the same parameters will retrieve
the entity IDs from the query cache and then load the actual entities from the second-level cache (or database if not
found there).

Configuration: To enable query caching, set hibernate.cache.use_query_cache to true in your Hibernate configuration and
use setCacheable(true) on your Query objects.

```Java

Query query = session.createQuery("from MyEntity where name = :name");
    query.

setParameter("name","Test");
    query.

setCacheable(true);
```

*Benefit*: Reduces the need to re-execute complex queries against the database, improving performance for repetitive
queries.

## Methods

a. Difference between get() & load(), save() & persist(), merge() & update()
b. Different entity states and which operation can be performed in which state? (Transient/Persistent/Detached)

![JPA Overview](../assets/img/diagram/jpa/ctxSession.png "JPA Overview")

The following outlines the differences between get() and load(), save() and persist(), and merge() and update() in
Hibernate:

**1. get() vs. load()**

get():
Immediately retrieves the object from the database or cache.
Returns null if no object is found with the given identifier.
Suitable when you need the object's data immediately and want to handle the case where it might not exist.

load():
Returns a proxy object without immediately hitting the database.
Loads the data only when a non-identifier property is accessed (lazy loading).
Throws ObjectNotFoundException if the object does not exist in the database when its data is accessed.
Suitable for performance optimization when you are certain the object exists and only need a reference initially.

**2. save() vs. persist()**

save():
Hibernate-specific method. Persists a transient instance and returns the generated identifier immediately. Can perform
an INSERT statement immediately, even outside of a transaction, if the identifier generator requires it (e.g., "
identity").

persist():
JPA-defined method. Makes a transient instance persistent within the current persistence context. Does not guarantee
immediate identifier assignment; it might happen at flush time. Guarantees that an INSERT statement will not be executed
if called outside of transaction boundaries.

**3. merge() vs. update()**

merge():
Attaches a detached entity to the current persistence context.
Returns a new persistent instance with the state of the detached object. The original detached object remains unchanged.
Performs a dirty check by selecting from the database before deciding whether to write its data. Suitable for
reattaching detached objects, especially when the detached object might have been modified in a different session.

update():
Reattaches a detached entity to the current persistence context. Modifies the given entity to become persistent. Always
persists its data to the database, whether it's dirty or not. Suitable when you are certain the detached object
corresponds to an existing database record and you want to directly update that record. If the object is new, it will
throw an exception.

Hibernate entities transition through various states, each dictating the operations that can be performed on them. The
three primary states are Transient, Persistent, and Detached.

**1. Transient State**

Characteristics: An object is in the transient state when it has been instantiated using the new operator but is not yet
associated with any Hibernate Session. It has no representation in the database, and no identifier value (ID) has been
assigned by Hibernate.

Operations:
Basic object manipulation (setting properties, calling methods).
Can be moved to the Persistent state using session.save(), session.persist(), or session.saveOrUpdate().

**2. Persistent State**

Characteristics: An object enters the persistent state when it is associated with a Hibernate Session and has a
corresponding entry in the database. Hibernate tracks changes made to persistent objects, and these changes are
synchronized with the database during flush operations.

Operations:
Modifications to the object's properties are automatically tracked and will be persisted to the database when the
session is flushed or committed.
Can be moved to the Detached state by closing the Session, committing the transaction, or using session.detach(). Can be
moved to the Removed state using session.delete() or session.remove().

**3. Detached State**

Characteristics: An object becomes detached when it was previously in a persistent state, but its associated Session has
been closed or the object has been explicitly detached. It still has an identifier value and a database representation,
but Hibernate no longer tracks its changes.

Operations:
Modifications made to a detached object are not automatically reflected in the database. Can be re-attached to a new
Session to become persistent again using session.update(), session.merge(), or session.saveOrUpdate(). When re-attached,
its changes can then be synchronized with the database.

## HQL, Named SQL Query and Criteria Query?

a. How and when to use which one?

Hibernate offers several ways to query data from a database: Hibernate Query Language (HQL), Named SQL queries, and
Criteria queries.

**1. Hibernate Query Language (HQL)**

What it is: An object-oriented query language, similar to SQL, but operating on persistent objects and their
properties (Java classes and their attributes) instead of database tables and columns. Hibernate translates HQL into SQL
for execution.

When to use: Ideal for static queries where the query structure is known beforehand. It's concise and readable,
especially when dealing with complex object relationships.
How to use:

```Java

String hql = "FROM Employee WHERE salary > :minSalary";
Query query = session.createQuery(hql);
    query.

setParameter("minSalary",50000);

List<Employee> employees = query.list();
```

**2. Named SQL Queries**

What it is: Predefined SQL queries (either native SQL or HQL) stored with a specific name, typically in mapping files or
using annotations (@NamedQuery, @NamedNativeQuery). These queries can be invoked by their name.

When to use: Suitable for frequently used, complex queries that are static and need to be easily reused across different
parts of the application. They offer better readability and maintainability by centralizing query definitions.

How to use:

```Java

// In your entity class (e.g., Employee.java)
@NamedQuery(name = "findEmployeesByDepartment", query = "FROM Employee e WHERE e.department.name = :deptName")

// In your code
Query query = session.getNamedQuery("findEmployeesByDepartment");
    query.

setParameter("deptName","IT");

List<Employee> employees = query.list();
```

**3. Criteria Queries**

What it is: An API for constructing dynamic, type-safe queries programmatically using Java objects. It allows building
queries by adding restrictions, ordering, and projections using methods and objects, rather than string manipulation.

When to use: Best for dynamic queries where the query conditions are determined at runtime, such as building search
filters based on user input. It offers type safety and helps prevent SQL injection vulnerabilities.

How to use:

```Java

CriteriaBuilder cb = session.getCriteriaBuilder();
CriteriaQuery<Employee> cq = cb.createQuery(Employee.class);
Root<Employee> root = cq.from(Employee.class);
    cq.

select(root).

where(cb.gt(root.get("age"), 30));
List<Employee> employees = session.createQuery(cq).getResultList();
```

**Choosing the right method**

HQL: For static, object-oriented queries.
Named Queries: For reusable, static HQL or native SQL queries.
Criteria Queries: For dynamic, type-safe queries built at runtime.

## What is cascading and what are different types of cascading?

In Hibernate, cascading is a feature that automatically propagates persistence operations, like save or delete, from a
parent entity to its associated child entities. The different types of cascading are defined by the CascadeType enum,
which includes ALL, PERSIST, MERGE, and REMOVE, controlling which operations are automatically applied to related
objects. For instance, setting CascadeType.REMOVE on a Customer entity will automatically delete its associated Order
entities when the customer is deleted.

**Types of cascading in Hibernate**

**CascadeType.ALL**: Propagates all primary cascade operations (persist, merge, remove, detach, refresh, etc.) from the
parent to the child entities.

**CascadeType.PERSIST**: Propagates a persist (save) operation. When the parent entity is saved, the child entities are
also saved.

**CascadeType.MERGE**: Propagates a merge (update) operation. When the parent entity is merged, the child entities are
also merged.

**CascadeType.REMOVE**: Propagates a remove (delete) operation. When the parent entity is deleted, its associated child
entities are also deleted.

**CascadeType.REFRESH**: Propagates a refresh operation. The state of the child entities is refreshed from the database
to match the parent entity's state.

**CascadeType.DETACH**: Propagates a detach operation. When the parent is detached from the persistence context, the
children are also detached.

**Other related options**

orphanRemoval: A property, distinct from cascade, that can be set on an association to automatically delete child
entities that are no longer associated with any parent. This is often used with CascadeType.ALL or CascadeType.PERSIST
on the @OneToMany side of a relationship.

Hibernate-specific cascades: Older, non-standard annotations like @Cascade offer more options but are generally not
recommended. It is best to stick to the standard JPA CascadeType enum unless a specific Hibernate feature is needed.

## What is lazy & eager loading in hibernate? What is N+1 SELECT problem in Hibernate?

**Lazy Loading**

Lazy loading is a strategy where associated entities or collections are loaded from the database only when they are
explicitly accessed for the first time. This means that when a parent entity is retrieved, its associated data is not
immediately loaded. Instead, a proxy object is created, and the actual data is fetched from the database only when a
method on that proxy is called, triggering the load. This approach can improve initial performance and reduce memory
consumption, as unnecessary data is not loaded.

**Eager Loading**

Eager loading is a strategy where associated entities or collections are loaded from the database immediately along with
the parent entity. When a parent entity is retrieved, all its eagerly fetched associations are also loaded in the same
query or a set of initial queries. This can be beneficial when the associated data is almost always needed, as it avoids
subsequent database calls. However, it can lead to fetching unnecessary data and potentially impact performance if the
associated data is large or frequently not used.

**N+1 SELECT Problem in Hibernate**

The N+1 SELECT problem is a performance anti-pattern that occurs when an application executes one query to retrieve a
collection of parent entities, and then executes an additional N queries (one for each parent entity) to retrieve their
associated child entities. This results in a total of N+1 database queries, where N is the number of parent entities.

Example:
Consider a scenario where you have a Company entity and an Employee entity with a one-to-many relationship (a company
has many employees). If you retrieve a list of Company objects and then iterate through each Company to access its
Employee collection (which is lazily loaded), Hibernate will execute:

One query to fetch all Company entities. N separate queries (where N is the number of companies) to fetch the employees
for each company when their respective getEmployees() method is called.

This leads to a significant performance degradation, especially with a large number of parent entities, due to the
numerous round-trips to the database.

**Solutions to the N+1 SELECT problem**

JOIN FETCH in HQL/JPQL: Explicitly fetching associated entities using JOIN FETCH to load them in a single query.

@EntityGraph: Defining a graph of entities and their associations to be fetched together.

Batch fetching: Configuring Hibernate to fetch a batch of associated entities in a single query.

## Explain different fetching strategies & Inheritance Mapping Strategies.

Hibernate Fetching Strategies
Hibernate offers several strategies to retrieve associated objects when navigating relationships, impacting performance
and resource usage:

Lazy Fetching (Default): Associated objects or collections are loaded only when they are explicitly accessed. This
avoids loading unnecessary data, optimizing initial load times.

Eager Fetching: Associated objects or collections are loaded immediately along with the primary entity. This can be
beneficial when the associated data is almost always needed, but can lead to performance issues if overused by loading
too much data.

Join Fetching: Hibernate retrieves the associated instance or collection in the same SELECT statement as the primary
entity, using an OUTER JOIN. This reduces the number of database queries.

Select Fetching: A separate SELECT statement is executed to retrieve the associated entity or collection. This is the
default when lazy fetching is enabled and the association is accessed.

Subselect Fetching: A second SELECT statement is used to retrieve the associated collections for all entities retrieved
in a previous query. This can be efficient for collections when multiple parent entities are loaded.

Hibernate Inheritance Mapping Strategies

Hibernate provides three main strategies to map Java inheritance hierarchies to a relational database:
Single Table Per Class Hierarchy (@Inheritance(strategy = InheritanceType.SINGLE_TABLE)):
All classes in the hierarchy are mapped to a single database table.
A "discriminator column" is used to identify the specific subclass stored in each row.
Pros: Good performance for polymorphic queries as only one table is accessed.
Cons: Columns specific to subclasses must be nullable, potentially impacting data integrity if not handled carefully.
Table Per Subclass (@Inheritance(strategy = InheritanceType.JOINED)):
Each class in the hierarchy (including the superclass) is mapped to its own table.
Subclass tables are joined to the superclass table using foreign keys.
Pros: Preserves database normalization, allows NOT NULL constraints on subclass-specific columns.
Cons: Requires joins for polymorphic queries, potentially impacting performance.
Table Per Concrete Class (@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)):
Each concrete (non-abstract) subclass is mapped to its own table, which includes all inherited and specific properties.
The superclass itself does not have a dedicated table.
Pros: No joins required for querying a specific concrete class.
Cons: Duplication of common properties across subclass tables, making polymorphic queries more complex (often requiring
UNION operations). Not supported for implicit polymorphism in all scenarios.

## Which annotation can be used to avoid a field from an entity to be persisted in DB?

(@Transient)

## Have you implemented any connection pooling in your application? If yes, which connection pool you have used? Benefits and drawbacks of using connection pooling?

When implementing a connection pool with Hibernate, HikariCP is often recommended due to its performance and efficiency.
Other viable options include ViburDBCP and c3p0, with c3p0 being a mature and widely deployed framework.
Benefits of Connection Pooling:
Improved Performance: Establishing a new database connection is a resource-intensive operation. Connection pooling
reuses existing connections, significantly reducing the overhead associated with connection creation and destruction,
leading to faster transaction response times.
Resource Management: Pools limit the number of active connections, preventing the database from becoming overwhelmed
during traffic spikes and ensuring efficient resource utilization.
Reduced Database Load: By reusing connections, the database experiences fewer connection establishment requests,
lessening its overall load.
Connection Management: Connection pools can handle issues like stale or broken connections, ensuring that only valid
connections are available for use.
Drawbacks of Connection Pooling:
Increased Complexity: Implementing and configuring a connection pool adds a layer of complexity to the application
architecture.
Potential for Resource Exhaustion: If the connection pool is not adequately sized or if connections are not properly
released, the pool can become exhausted, leading to application errors and performance degradation.
Overhead in Specific Scenarios: For applications with very low and infrequent database interaction, the overhead of
managing a connection pool might outweigh the benefits. For instance, in a batch job where connections are used once and
then discarded, pooling might not be advantageous.
Configuration Challenges: Improper configuration of pool parameters (e.g., maximum pool size, connection timeout) can
lead to performance bottlenecks or resource issues.

## How to resolve LazyInitializationException & OptimisticLockException in Hibernate?

Resolving LazyInitializationException in Hibernate

A LazyInitializationException occurs when a lazily loaded association is accessed outside of an active Hibernate
session. To resolve this, ensure the associated data is fetched within the session context.
Strategies:

Initialize associations within the service layer:

JOIN FETCH Clause: Use LEFT JOIN FETCH in JPQL or Criteria API queries to explicitly fetch required associations
alongside the main entity.

Java

        SELECT e FROM EntityName e LEFT JOIN FETCH e.associatedCollection

Named Entity Graphs: Define reusable entity graphs using @NamedEntityGraph annotations or the EntityGraph API to specify
which relationships to fetch.

Java

        @NamedEntityGraph(name = "entity-with-collection", attributeNodes = @NamedAttributeNode("associatedCollection"))

Hibernate.initialize(): Manually initialize a lazy collection or proxy within an active session.

Java

        Hibernate.initialize(entity.getLazyCollection());

Use DTO Projections: For read-only operations, project the required data directly into Data Transfer Objects (DTOs)
instead of entities. DTOs are fully initialized and do not rely on lazy loading.
FetchType.EAGER (Use with caution): Change the FetchType of the association to EAGER. This ensures the association is
always loaded with the parent entity but can negatively impact performance if the association is not always needed.
Open Session In View (OSIV): In web applications, OSIV keeps the Hibernate session open throughout the request
lifecycle, allowing access to lazy associations in the view layer. While convenient, it can mask underlying fetching
issues and lead to performance problems if not used carefully.
Resolving OptimisticLockException in Hibernate
An OptimisticLockException indicates that an entity was modified by another transaction between when it was loaded and
when it was attempted to be updated. Hibernate's optimistic locking mechanism, typically using a version column, detects
this conflict.
Strategies:
Version Column Management: Ensure your entity includes a version column (e.g., @Version Long version) that Hibernate
automatically manages to detect concurrent modifications.
Retry Mechanism: Implement a retry mechanism in your application logic to re-fetch the entity and re-attempt the update
if an OptimisticLockException occurs. This allows the user to re-evaluate the changes based on the latest data.
User Notification and Conflict Resolution: When an OptimisticLockException occurs, inform the user about the conflict
and provide options to resolve it (e.g., discard their changes and reload the latest version, or manually merge
changes).
Refresh Entity: If an entity is updated multiple times within the same transaction without being reloaded, the version
might become stale. Ensure to refresh the entity from the database to get the latest version before performing
subsequent updates.
Java

    entityManager.refresh(entity);

## What is optimistic and pessimistic locking and which one should be used on scenario basis?

Optimistic locking allows multiple users to access data simultaneously, checking for conflicts only when a transaction
is committed using a version number, while pessimistic locking locks data as it is read, preventing other users from
accessing it until the transaction is complete. Choose optimistic locking for scenarios with low conflict, like general
browsing, as it offers higher concurrency. Use pessimistic locking when conflicts are frequent and data integrity is
critical, such as during flash sales or financial transactions, because it prevents conflicts from occurring.
Optimistic locking
How it works: Transactions read data without locking it. A version number or timestamp is associated with the data. When
a transaction is committed, Hibernate checks if the version number in the database matches the one the transaction read.
If it doesn't, another transaction has modified the data, and the current transaction fails.
When to use:
Low conflict: The probability of two users trying to update the same record at the same time is low.
High concurrency: It allows for more simultaneous access, which improves performance in read-heavy applications.
Example: General product browsing or a user editing their profile information.
Pessimistic locking
How it works: When a transaction reads a record, it locks it, preventing other transactions from reading or writing to
it until the lock is released. Hibernate provides mechanisms to implement this, such as using database-level locks like
SELECT ... FOR UPDATE.
When to use:
High conflict: You expect frequent conflicts or high contention for a specific resource.
Data integrity: Data consistency is paramount, and you cannot afford to have failed transactions.
Example: A reservation system for the last seat on a flight or a high-demand flash sale event.

## What is flush() method and when to use it?

In Hibernate, the flush() method is used to synchronize the state of the in-memory persistence context (where managed
entities reside) with the underlying database. This means that any pending changes to managed entities (inserts,
updates, deletes) are translated into SQL statements and sent to the database.
When to use flush():
While Hibernate often handles flushing automatically (e.g., before queries in AUTO flush mode, or at transaction
commit), there are specific scenarios where explicitly calling session.flush() or entityManager.flush() is beneficial or
necessary:
Ensuring Data Availability for Native SQL Queries or Read Operations: If you perform a series of entity modifications
and then immediately execute a native SQL query or a read operation that depends on those modifications, explicitly
flushing ensures the database is up-to-date before the query runs. This is crucial for "read-your-own-writes"
consistency.
Early Detection of Database Constraint Violations: Flushing early within a transaction can help detect database
constraint violations (like NOT NULL or UNIQUE constraints) sooner, rather than waiting until the transaction commit.
This can simplify debugging and error handling.
Managing Memory in Batch Processing: In scenarios involving large-scale batch processing, periodically flushing changes
to the database can help manage memory usage by preventing Hibernate from holding too many managed entities in memory
for the entire transaction.
Specific Flush Modes (e.g., MANUAL): If you configure Hibernate's FlushMode to MANUAL, you are responsible for
explicitly calling flush() whenever you want the changes to be synchronized with the database. This mode is often used
in read-only transactions for performance optimization.
Interacting with External Systems or Logic: When your application interacts with external systems or performs logic that
relies on the most current database state within a single transaction, flushing can ensure that the external system or
logic operates on up-to-date data.
Example of explicit flush:
Java

Session session = sessionFactory.openSession();
Transaction tx = null;
try {
tx = session.beginTransaction();

    // Modify entities
    User user = session.get(User.class, 1L);
    user.setName("New Name");
    session.save(new Product("New Product"));

    session.flush(); // Explicitly flush changes to the database

    // Now, a native SQL query or a dependent operation can be executed
    // knowing the changes are reflected in the database.
    // For example, a native query to get the newly added product's ID.

    tx.commit();

} catch (HibernateException e) {
if (tx != null) tx.rollback();
e.printStackTrace();
} finally {
session.close();
}

## How can you define relationships in different entities?

a. OneToOne/OneToMany/ManyToOne/ManyToMany?
b. What is the use of @MappedBy annotation?
c. By default how many tables will get created in different types of entity relationships?
d. How many tables are min required for a ManyToMany relationship?

Here is information regarding defining relationships in entities:
a. OneToOne/OneToMany/ManyToOne/ManyToMany
These terms describe the cardinality of relationships between entities in a database:
OneToOne: A single instance of Entity A is associated with a single instance of Entity B, and vice versa. For example, a
Person and their Passport.
OneToMany: A single instance of Entity A is associated with multiple instances of Entity B, but each instance of Entity
B is associated with only one instance of Entity A. For example, a Customer and their Orders.
ManyToOne: Multiple instances of Entity A are associated with a single instance of Entity B, and each instance of Entity
B is associated with multiple instances of Entity A. This is the inverse of OneToMany. For example, multiple Orders
belonging to a single Customer.
ManyToMany: Multiple instances of Entity A are associated with multiple instances of Entity B, and vice versa. For
example, Students and Courses (a student can take many courses, and a course can have many students).
b. Use of @MappedBy annotation
The @MappedBy annotation is used in bidirectional relationships to indicate the "inverse" side of the relationship. It
specifies the field in the owning entity that defines the relationship. This tells the persistence provider (like
Hibernate) that the current entity is not responsible for managing the foreign key, and that the relationship is already
mapped by the specified field in the other entity. This prevents the creation of an unnecessary join table or redundant
foreign key columns.
c. Default table creation in different types of entity relationships
OneToOne: By default, two tables are created, one for each entity. The foreign key for the relationship typically
resides in one of the tables (often the "dependent" entity).
OneToMany/ManyToOne: By default, two tables are created, one for each entity. The foreign key is typically placed in the
table on the "many" side of the relationship.
ManyToMany: By default, three tables are created: one for each entity, and a third "join table" or "association table"
to manage the relationship between them. This join table contains foreign keys referencing the primary keys of both
participating entities.
d. Minimum tables required for a ManyToMany relationship
A minimum of three tables are required for a ManyToMany relationship: one for each of the two entities involved, and one
intermediate join table to store the associations between them.
