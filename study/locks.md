# Database locks

Pessimistic and optimistic locking are two strategies for managing concurrent access to data in a database, ensuring
data integrity and preventing conflicts.

**Pessimistic Locking**:

Mechanism: This approach assumes that conflicts are likely, so it locks the data resource (e.g., a row, table, or page)
immediately when a transaction begins to read or modify it. This lock prevents other transactions from accessing or
modifying the locked data until the current transaction commits or rolls back.
Pros: Guarantees data consistency by preventing concurrent modifications. Simpler to implement in some scenarios as
conflicts are prevented proactively.
Cons: Can lead to performance bottlenecks and reduced concurrency, especially in high-traffic systems, as other
transactions might have to wait for locks to be released. Increases the risk of deadlocks if not managed carefully.
Use Cases: Suitable for scenarios where data conflicts are highly probable and data integrity is paramount, such as
financial transactions, inventory management, or booking systems where simultaneous updates to the same resource are
frequent.

**Optimistic Locking:**

**Mechanism**: This approach assumes that conflicts are rare. It does not lock the data resource during the read phase.
Instead, it uses a versioning mechanism (e.g., a version number or timestamp column) to detect conflicts at the time of
updating. When a transaction attempts to commit changes, it checks if the data has been modified by another transaction
since it was initially read. If a conflict is detected, the transaction is typically rolled back, and the application
needs to handle the conflict (e.g., by prompting the user to re-read and re-apply changes).

**Pros**: Higher concurrency and better performance in environments with low contention, as locks are not held for
extended periods. Reduces the risk of deadlocks.
Cons: Requires more complex application-level logic to handle conflict detection and resolution. Might lead to "false
positives" where a conflict is detected even if the changes are non-overlapping.

**Use Cases**: Ideal for applications with high read volumes and a lower likelihood of concurrent updates, such as
content management systems, social media platforms, or user profile management where concurrent edits to the exact same
record are less common.

# which sql command mysql use pessimistic lock at defautl?

In MySQL, specifically with the InnoDB storage engine which is the default for new tables, the following SQL commands
can apply pessimistic locks:

**SELECT ... FOR UPDATE**: This statement acquires an exclusive (X) lock on the selected rows. This means other
transactions cannot read (with FOR UPDATE), modify, or delete these rows until the lock is released (by committing or
rolling back the transaction). This is the most common way to implement pessimistic locking for write operations.

```sql

    START TRANSACTION;
    SELECT * FROM accounts WHERE id = 1 FOR UPDATE;
    -- Perform updates or other operations on the locked row
    COMMIT;
```

**SELECT ... FOR SHARE (formerly SELECT ... LOCK IN SHARE MODE)**: This statement acquires a shared (S) lock on the
selected rows. This allows other transactions to also acquire shared locks on the same rows (meaning multiple
transactions can read them concurrently), but it prevents any other transaction from acquiring an exclusive lock (i.e.,
modifying or deleting the rows) until all shared locks are released.

```sql

    START TRANSACTION;
    SELECT * FROM products WHERE category = 'electronics' FOR SHARE;
    -- Perform read-only operations
    COMMIT;
```

**Important Considerations**

**Transaction Context**: These locking reads (FOR UPDATE, FOR SHARE) only have an effect within a transaction. They must
be enclosed within START TRANSACTION and COMMIT or ROLLBACK.

**Row-Level Locking**: InnoDB primarily uses row-level locking. However, if the WHERE clause in your SELECT ... FOR
UPDATE or SELECT ... FOR SHARE statement does not use an index to precisely identify records, InnoDB might escalate to
locking gaps between rows (Next-Key Locks) or even the entire table to prevent "phantom reads," depending on the
isolation level.

**Default Behavior**: The default behavior of FOR UPDATE and FOR SHARE is to wait if a requested row is already locked
by another transaction, until the innodb_lock_wait_timeout is exceeded. MySQL 8 introduced NOWAIT and SKIP LOCKED
clauses to modify this waiting behavior.

# which are the sql command in mysql that use optimistic lock?

MySQL's InnoDB storage engine, which is the default, utilizes Multi-Version Concurrency Control (MVCC) as its primary
mechanism for concurrency control. MVCC is a form of optimistic concurrency control. This means that no specific SQL
commands inherently trigger optimistic locking by default in the way that pessimistic locking uses explicit FOR UPDATE
clauses.

Instead, optimistic locking in MySQL (and other MVCC-based systems) is handled implicitly by the database engine and
requires a specific application-level pattern to be implemented to detect and handle conflicts.
Here's how it works and what SQL commands are involved in

**implementing optimistic locking**

Version Column: You add a version (e.g., an integer or timestamp) column to your table.
Read: When you read data, you also read the current version value.

```sql

    SELECT data_column, version_column FROM your_table WHERE id = 123;
```

Update: When you update the data, you include the previously read version in the WHERE clause and increment the version
column.

```sql

    UPDATE your_table
    SET data_column = 'new_value', version_column = version_column + 1
    WHERE id = 123 AND version_column = @old_version;
```

**Conflict Detection**: The success of the UPDATE statement (checked by the number of affected rows) indicates whether a
conflict occurred. If AffectedRows == 0, it means another transaction modified the row and incremented the
version_column since you read it, thus preventing your update. You would then handle this conflict in your application (
e.g., retry the operation, inform the user).

**In summary:**
Optimistic locking in MySQL is not a feature triggered by specific SQL commands but rather a design pattern implemented
at the application level using standard SELECT and UPDATE statements in conjunction with a versioning mechanism in your
table schema. MVCC, the underlying concurrency control mechanism in InnoDB, facilitates this optimistic approach by
allowing multiple transactions to read different versions of the same data without blocking each other.