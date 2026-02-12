# JPA & Hibernate
JPA

# Hibernate advantages

Hibernate offers several advantages over raw JDBC for interacting with databases in Java applications:

**Object-Relational Mapping (ORM)**

Hibernate automates the mapping between Java objects and database tables, eliminating the need for manual SQL query writing and result set parsing. This significantly reduces boilerplate code and development time.<br>

**Database Independence**

Hibernate's HQL (Hibernate Query Language) and Criteria API are database-independent, allowing applications to switch between different database systems with minimal code changes. JDBC, in contrast, requires database-specific SQL queries.<br>

**Reduced Boilerplate Code**

Hibernate handles connection management, transaction management, and resource closing automatically, freeing developers from writing repetitive JDBC code.<br>

**Caching Mechanisms**

Hibernate includes built-in caching (first-level and second-level) to reduce database roundtrips and improve application performance. JDBC does not offer such built-in caching.<br>

**Lazy Loading**

Hibernate supports lazy loading, where related objects are only loaded from the database when they are actually accessed, optimizing resource usage and performance.<br>

**Simplified Exception Handling**

Hibernate converts checked SQLExceptions into unchecked RuntimeExceptions, simplifying error handling and reducing the need for extensive try-catch blocks.<br>

**Support for Object-Oriented Concepts**

Hibernate seamlessly supports object-oriented features like inheritance, polymorphism, and associations (one-to-one, one-to-many, many-to-one, many-to-many), making database interactions more natural for Java developers.<br>

**Improved Maintainability and Scalability**

The higher level of abstraction and reduced code complexity offered by Hibernate generally leads to more maintainable and scalable applications compared to those built with raw JDBC.<br>


# What are SessionFactory and Session? Are they thread-safe?

***SessionFactory***
A heavyweight, application-scoped, immutable factory that creates Session instances. It holds second-level cache, mappings, and configuration metadata.<br>

✅ Thread-safe (should be one per database).<br>

***Session***<br>
A lightweight, short-lived unit-of-work object that represents a single interaction with the database and holds the first-level cache (persistence context).<br>

❌ Not thread-safe (one per request/transaction).<br>

# Is Session the same as the PersistenceContext?<br>

Not exactly.<br>

A Session contains a PersistenceContext.<br>

The PersistenceContext is the first-level cache that tracks managed entities and their state.<br>

So: Session ≠ PersistenceContext, but Session manages one.<br>

Session = API + lifecycle + transaction boundary + persistence context holder.<br>

PersistenceContext = internal state (first-level cache + entity tracking).<br>

They are strongly related but not identical.<br>

# Why and when do we need to detach an entity?

An entity is detached when it is no longer associated with a persistence context.<br>

We detach when:<br>

Sending entities to another layer (e.g., DTO boundary).<br>

Preventing unintended updates (avoid dirty checking).<br>

Long-running processes where keeping entities managed would cause memory overhead.<br>

Closing the Session/transaction (automatic detachment).<br>

Detached entities must be reattached (merge or update) to persist changes.<br>


# What is dirty checking?

Dirty checking is Hibernate’s mechanism that:<br>

Tracks managed entities inside the persistence context.<br>

Compares their current state with the original snapshot.<br>

Automatically issues UPDATE statements at flush/commit time if changes are detected.<br>

No explicit update() call is required for managed entities.<br>


# What is Hibernate caching? Explain first-level cache.

Hibernate caching is a mechanism to reduce database hits by storing entities in memory.<br>

***First-level cache (L1):***<br>

Associated with a Session.

Enabled by default.

Stores managed entities inside the persistence context.<br>

Scope: one session/transaction.<br>

Cannot be disabled.<br>

Ensures the same entity ID is loaded only once per session.<br>

Example:<br>

Calling session.get(User.class, 1L) twice in the same session hits the DB only once.<br>

# How to configure second-level caching?

Second-level cache (L2):<br>

Shared across Sessions.<br>

Optional (disabled by default).<br>

Requires a cache provider (e.g., Ehcache, Caffeine, Infinispan).<br>

Steps:<br>

Add cache provider dependency.<br>

Enable L2 cache:<br>

```properties
hibernate.cache.use_second_level_cache=true
hibernate.cache.region.factory_class=org.hibernate.cache.jcache.JCacheRegionFac
```

Mark entities as cacheable:<br>

```java
@Entity
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class User { }
```

Now entities can be reused across sessions without hitting the DB.<br>


# What is query-level cache?

Query cache stores query result identifiers, not entities themselves.<br>

Must enable:<br>
```properties
hibernate.cache.use_query_cache=true
```

Activate per query:<br>
```java
query.setCacheable(true);
```

Important:<br>

It caches the result IDs list, not the actual objects.<br>

Works best together with second-level cache.<br>

Sensitive to updates (invalidated when related entities change).<br>

```java

@Entity
@Cacheable
@org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class MyEntity {
    // ...
}
```


```Java

Query query = session.createQuery("from MyEntity where name = :name");
    query.

setParameter("name","Test");
    query.

setCacheable(true);
```


# get() & load(), save() & persist(), merge() & update()

***get() vs load()***<br>

***get():***	<br>
Hits DB immediately	<br>
Returns null if not found <br>	
No proxy by default <br>
Safer for existence check <br>	

***load():***<br>
Returns proxy (lazy)<br>
Throws ObjectNotFoundException when accessed <br>
Uses proxy<br>
Better for performance when existence is guaranteed<br>

Use get() when unsure if entity exists.<br>
Use load() when you know it exists and want lazy behavior.<br>

***save() vs persist()***<br>

***save()***<br>
Returns generated ID <br>
May execute INSERT immediately<br>
Hibernate-specific<br>
Can assign ID outside transaction<br>

***persist()***<br>
Returns void<br>
Delays INSERT until flush<br>
JPA standard<br>
Requires active transaction<br>

Prefer persist() in JPA-based applications.<br>

***merge() vs update()***<br>

***merge():*** <br>
Copies state into managed entity<br>
Returns managed instance<br>
Safe if entity already managed<br>
Works with detached entities safely<br>

***update():***<br>
Reattaches same instance<br>
Returns void<br>
Throws exception if same ID already in session<br>
Risk of NonUniqueObjectException<br>

Prefer merge() in layered architectures.<br>

# What are Entity States and theirs Allowed Operations?

1️⃣ Transient<br>

Not associated with Session.<br>

No DB record.<br>

Created via new.<br>

Allowed:<br>

persist()<br>

save()<br>

2️⃣ Persistent (Managed)<br>

Associated with Session.<br>

Tracked by persistence context.<br>

Dirty checking active.<br>

Allowed:<br>

Automatic updates via dirty checking<br>

remove()<br>

detach()<br>

refresh()<br>

No need to call update().<br>

3️⃣ Detached<br>

Has DB identity.<br>

Not associated with Session.<br>

Occurs after session close/clear.<br>

Allowed:<br>

merge()<br>

update() (careful)<br>

delete()<br>

Cannot trigger dirty checking unless reattached.<br>

Quick Mental Model<br>

Transient → persist() → Persistent → (session close) → Detached → merge() → Persistent again.<br>

# HQL, Named SQL Query and Criteria Query?

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

# What is cascading and what are different types of cascading?

What is Cascading?<br>

Cascading defines how operations performed on a parent entity are automatically propagated to its associated child entities.<br>

It controls lifecycle propagation across entity relationships (@OneToMany, @ManyToOne, @OneToOne, @ManyToMany).<br>

Without cascade → you must manually persist/remove children.<br>
With cascade → Hibernate propagates the operation automatically.<br>

Cascade Types (JPA)<br>

1️⃣ CascadeType.PERSIST<br>

Propagates persist()<br>
When parent is saved → children are saved.<br>

2️⃣ CascadeType.MERGE<br>

Propagates merge()<br>
When parent is merged → detached children are merged.<br>

3️⃣ CascadeType.REMOVE<br>

Propagates remove()<br>
When parent is deleted → children are deleted.<br>

⚠ Use carefully in @ManyToMany.<br>

4️⃣ CascadeType.REFRESH<br>

Propagates refresh()<br>
Reloads children from DB when parent is refreshed.<br>

5️⃣ CascadeType.DETACH<br>

Propagates detach()<br>
Children become detached when parent is detached.<br>

6️⃣ CascadeType.ALL<br>

Includes all of the above.<br>

Hibernate-Specific Cascade<br>

Hibernate also supports:<br>

SAVE_UPDATE<br>

REPLICATE<br>

LOCK<br>

(Non-standard, rarely needed in modern JPA-based apps.)<br>

Important Clarification (Interview Trap)<br>

Cascade ≠ FetchType<br>

Cascade → lifecycle propagation<br>

FetchType → loading strategy (EAGER/LAZY)<br>

They solve different problems.<br>


# What is Lazy and Eager Loading?

Lazy Loading (FetchType.LAZY)<br>

Related entities are not loaded immediately.<br>

Loaded only when accessed.<br>

Implemented using proxies.<br>

Example:<br>

```java
@OneToMany(fetch = FetchType.LAZY)
```

✅ Better performance by default<br>
⚠ Can cause LazyInitializationException if accessed outside session<br>

Eager Loading (FetchType.EAGER)<br>

Related entities are loaded immediately with parent.<br>

Happens via JOIN or additional select.<br>

Example:<br>
```java
@ManyToOne(fetch = FetchType.EAGER)
```

⚠ Can impact performance if overused<br>
⚠ May load unnecessary data<br>

# What is N+1 SELECT Problem?

Occurs when:<br>

1 query loads parent entities<br>

N queries load each child individually<br>

Example:<br>

```txt
Load 100 Orders → 1 query
```

Access each Order's Customer → 100 additional queries<br>
Total = 101 queries<br>

That’s N+1.<br>

***Why It Happens***<br>

Usually caused by:<br>

Lazy relationships<br>

Iterating over collection and accessing child entities<br>

***How to Solve***<br>

JOIN FETCH<br>

EntityGraph<br>

Batch fetching<br>

Proper query design<br>

Example:<br>

```sql
SELECT o FROM Order o JOIN FETCH o.customer
```

Interview Insight<br>

LAZY is safer default.<br>
EAGER is dangerous by default.<br>
N+1 is a query design problem — not strictly a Hibernate bug.<br>

Scenario: Looks Optimized… But Isn’t<br>

You write:<br>

```sql
SELECT o FROM Order o
```

Order has:<br>

```java
@ManyToOne(fetch = FetchType.LAZY)
private Customer customer;
```

You think:<br>

“Good. LAZY. No problem.”<br>

Then in service layer:<br>

```java
List<Order> orders = orderRepository.findAll();

for (Order o : orders) {
    System.out.println(o.getCustomer().getName());
}
```

***What Actually Happens***<br>


Then for each order:<br>

```sql
SELECT * FROM customer WHERE id = ?;
If 200 orders → 201 queries.
```

Classic N+1.<br>

Now The Senior-Level Trap<br>

You try to fix it with:<br>

```java
@Query("SELECT o FROM Order o JOIN FETCH o.customer")
```

It works. 🎉<br>

Until...<br>

You add pagination:<br>

```java
Page<Order> page = orderRepository.findAll(PageRequest.of(0, 20));
```


Hibernate now:<br>

Either throws exception<br>

Or ignores fetch join<br>

Or produces duplicated results<br>

Because JOIN FETCH + pagination on collections is problematic.<br>

The Deeper Trap<br>

Now imagine:<br>
```
Order
  -> @OneToMany List<OrderItem>
OrderItem
  -> @ManyToOne Product
```


You fetch:<br>


```java
SELECT o FROM Order o
JOIN FETCH o.items
JOIN FETCH o.items.product
```

If:<br>

1 order has 10 items<br>

20 orders total<br>

Result set = 200 rows (cartesian multiplication)<br>

Memory spike. Duplicate parent objects internally handled. Performance tanks.<br>

This is not N+1 anymore.<br>

This is ***Cartesian explosion***.<br>

Real Senior Fix Strategies<br>

✔ Use @EntityGraph<br>
✔ Use batch fetching:<br>

```java
hibernate.default_batch_fetch_size=16
```

✔ Use DTO projection queries<br>
✔ Fetch only what the screen needs<br>
✔ Avoid fetching collections when paginating<br>

Interview Power Move<br>

Say this:<br>

"N+1 is usually a symptom of poor query design, not just lazy loading. Sometimes fixing it with JOIN FETCH introduces cartesian product issues, so DTO projection or batch fetching can be safer."<br>

That’s senior-level maturity.<br>

# Which annotation can be used to avoid a field from an entity to be persisted in DB?

(@Transient)

# Have you implemented any connection pooling in your application?


Have you implemented connection pooling?<br>

Yes. In modern Spring Boot applications, connection pooling is typically handled automatically by the framework.<br>

Most commonly used:<br>

HikariCP (default in Spring Boot 2+)<br>

Previously: C3P0, Apache DBCP<br>

In production systems, I’ve used HikariCP because it offers better performance and lower latency.<br>

Which connection pool have you used?<br>

HikariCP<br>

Why?<br>

Very lightweight<br>

High-performance<br>

Low memory footprint<br>

Better timeout handling<br>

Fast acquisition/release time<br>

Example config:<br>

```java
spring.datasource.hikari.maximum-pool-size=20
spring.datasource.hikari.minimum-idle=5
spring.datasource.hikari.connection-timeout=30000
```

Benefits of Connection Pooling<br>

Performance<br>

Creating DB connections is expensive (~10–50ms depending on DB).<br>

Pooling reuses connections.<br>

Resource Management<br>

Prevents DB overload.<br>

Controls max active connections.<br>

Scalability<br>

Handles concurrent requests efficiently.<br>

Reduced Latency<br>

No need to open/close connections per request.<br>

Drawbacks / Risks<br>

Misconfiguration<br>

Pool too small → bottlenecks.<br>

Pool too large → DB exhaustion.<br>

Connection Leaks<br>

Not closing connections properly can exhaust pool.<br>

Idle Connections<br>

May hold unused DB resources.<br>

Deadlocks Under High Load<br>

If threads block waiting for connections.<br>

# How to resolve LazyInitializationException & OptimisticLockException in Hibernate?

Why it happens<br>

It occurs when:<br>

A LAZY association is accessed<br>

After the Hibernate Session is closed<br>

Example:<br>

```java
order.getItems().size(); // outside transaction
```

Hibernate cannot load data because there is no active persistence context.<br>


❌ Wrong “solutions”<br>

Changing everything to EAGER (creates performance problems)<br>

Enabling OpenSessionInView blindly (hides architectural issues)<br>

✅ Proper Solutions<br>
1. Fetch what you need inside transaction (Best practice)<br>

Use JOIN FETCH:<br>
```sql
SELECT o FROM Order o JOIN FETCH o.items
```

Or use @EntityGraph.<br>

2. Use DTO projection<br>

Instead of returning entities:<br>

```sql
SELECT new com.dto.OrderDTO(o.id, c.name)
FROM Order o JOIN o.customer c
```

Best for APIs.<br>

3. Enable OpenSessionInView (with caution)<br>

Keeps session open during request lifecycle.<br>
Convenient but can cause hidden N+1 issues.<br>

Senior-Level Statement<br>

LazyInitializationException is usually a design issue — not a fetch-type issue.<br>

***How to resolve OptimisticLockException?***<br>
Why it happens<br>

Occurs when:<br>

Two transactions update the same entity<br>

Version mismatch detected<br>

Requires:<br>

```java
@Version
private Long version;
```

Hibernate adds:<br>

```sql
WHERE id = ? AND version = ?
```

If update count = 0 → OptimisticLockException.<br>

✅ Proper Solutions<br>
1. Use @Version (mandatory for optimistic locking)<br>

Without versioning, you don’t have real optimistic locking.<br>

2. Handle exception and retry<br>

Example strategy:<br>

Catch OptimisticLockException<br>

Reload entity<br>

Reapply changes<br>

Retry transaction<br>

Often used in high-concurrency systems.<br>

3. Switch to pessimistic locking (if needed)<br>
```java
entityManager.lock(entity, LockModeType.PESSIMISTIC_WRITE);
```

But:<br>

Reduces concurrency<br>

Can cause deadlocks<br>

When to Use Each<br>

Optimistic → Read-heavy systems<br>

Pessimistic → High-contention write-heavy systems<br>

Strong Interview Close<br>

Say this:<br>

"Optimistic locking prevents lost updates without database-level blocking, but it requires proper exception handling and retry strategy."<br>

That’s mature.<br>

# What is optimistic and pessimistic locking and which one should be used on scenario basis?

Optimistic vs Pessimistic Locking<br>

🔵 Optimistic Locking<br>

Assumes:<br>

Conflicts are rare.<br>

Mechanism:<br>

Uses a @Version field.<br>

No DB lock while reading.<br>

At update time, checks version.<br>

Example:<br>

```java
@Version
private Long version;
```

Generated SQL:<br>

```java
UPDATE order 
SET status=?, version=? 
WHERE id=? AND version=?;
```

If version changed → OptimisticLockException.<br>

✅ Pros<br>

High concurrency<br>

No blocking<br>

Better performance in read-heavy systems<br>

❌ Cons<br>

Requires retry logic<br>

Fails at commit time (late detection)<br>

🔴 Pessimistic Locking<br>

Assumes:<br>

Conflicts are likely.<br>

Mechanism:<br>

Locks row at DB level.<br>

Other transactions must wait.<br>

Example:<br>

```java
entityManager.find(Order.class, id, LockModeType.PESSIMISTIC_WRITE);
```

SQL:<br>

```sql
SELECT ... FOR UPDATE;
```

✅ Pros<br>
Prevents concurrent modification immediately<br>

No retry logic needed<br>

❌ Cons<br>

Lower concurrency<br>

Risk of deadlocks<br>

Can reduce system throughput<br>

2️⃣ When to Use Each?<br>

| Scenario                               | Recommended  |
|----------------------------------------|-------------|
| Read-heavy system                     | Optimistic  |
| Rare conflicts                        | Optimistic  |
| High contention updates               | Pessimistic |
| Financial transaction with high conflict risk | Pessimistic |
| Long-running business transaction     | Optimistic  |


Strong Senior-Level Answer<br>

Use optimistic locking by default. Switch to pessimistic only when you measure frequent update conflicts and retries become costly.<br>

Default to optimistic. Escalate only if data shows contention.<br>

3️⃣ About Your JOIN FETCH / @EntityGraph Note<br>

If your concern is resolving LazyInitializationException:<br>

```java
SELECT o FROM Order o JOIN FETCH o.items
```

This forces eager loading in that query only.<br>

Alternative:<br>

```java
@EntityGraph(attributePaths = {"items"})
```

Difference:<br>

```sql
JOIN FETCH → Hardcoded in JPQL
```

```java
@EntityGraph → More flexible, reusable, cleaner with Spring Data
```
Both solve lazy loading per query — without globally switching to EAGER.<br>

💰 Scenario: Banking Transfer<br>

You have this method:<br>

```java
@Transactional
public void transfer(Long fromId, Long toId, BigDecimal amount) {
    Account from = accountRepository.findById(fromId).orElseThrow();
    Account to   = accountRepository.findById(toId).orElseThrow();

    from.debit(amount);
    to.credit(amount);
}
```

System:<br>

10,000 concurrent users<br>

Same account may receive multiple transfers simultaneously<br>

Now the question:<br>

👉 Would you use optimistic or pessimistic locking?<br>

❌ Junior Instinct<br>

“Money = critical = use pessimistic locking.”<br>

Sounds safe. But think deeper.<br>

🔍 What Actually Happens with Pessimistic<br>

If you use:<br>

```java
@Lock(LockModeType.PESSIMISTIC_WRITE)
```

Then:<br>

DB locks row immediately.<br>

Other transfers wait.<br>

Under high load → threads pile up.<br>

Throughput collapses.<br>

Risk of deadlocks (especially transferring A→B and B→A).<br>

You made it “safe” but possibly unscalable.<br>

🔵 What Happens with Optimistic<br>

Using:
```java
@Version
private Long version;
```

Two transfers read same version.<br>

First commits → version increments.<br>
Second commits → fails with OptimisticLockException.<br>

Then you:<br>

Retry transaction.<br>

Recalculate balance.<br>

Commit again.<br>

Under moderate contention → this scales better.<br>

⚖️ So Which One?<br>
Case 1: Normal retail banking (many accounts, low collision per account)<br>

👉 Optimistic wins.<br>

Because:<br>

Most users operate on different accounts.<br>

Conflict probability per row is low.<br>

Retries are rare.<br>

Case 2: High-frequency trading system<br>

👉 Pessimistic may be safer.<br>

Because:<br>

Same account updated constantly.<br>

Retry storms would degrade system.<br>

🧠 The Real Senior Insight<br>

The decision is not about:<br>

“Money = lock harder”<br>

It’s about:<br>

Collision probability<br>

Throughput requirements<br>

Retry cost vs blocking cost<br>

Deadlock risk<br>

🔥 Extra Twist (Interview Killer Question)<br>

What if:<br>

Transfer A → B<br>

Simultaneously B → A<br>

With pessimistic locking:<br>

ransaction 1 locks A<br>

Transaction 2 locks B<br>

Both try to lock the other<br>

Deadlock.<br>

Now what?<br>

Correct answer:<br>

Always lock rows in consistent order (e.g., smaller ID first).<br>

Example:
```java
Long first = Math.min(fromId, toId);
Long second = Math.max(fromId, toId);
```

That avoids deadlocks.<br>

Final Power Statement<br>

Locking strategy is not about safety alone. It's about balancing consistency, throughput, and contention patterns.<br>


# How can you define relationships in different entities?

a. OneToOne/OneToMany/ManyToOne/ManyToMany?
b. What is the use of @MappedBy annotation?
c. By default how many tables will get created in different types of entity relationships?
d. How many tables are min required for a ManyToMany relationship?

