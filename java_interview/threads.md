# Multithreading & Java Concurrency

#### 1. [Multithread environment](#multithread-enviroment)

#### 2. [Thread-safe code](#thread-safe-code)

#### 3. [Runnable vs Callable](#runnable-vs-callable)

#### 4. [UncaughtExceptionHandler](#uncaughtexceptionhandler)

#### 5. [Thread-scheduling](#thread-scheduling)

#### 6. [Thread execution](#thread-execution)

#### 7. [Thread life cycle](#thread-life-cycle)

#### 8.[fork-join](#forkjoin)

#### 9. [Thread Dumps](#thread-dumps)

#### 10. [Executor framework](#executor-framework)

#### 11. [Threadlocal](#threadlocal)

#### 12. [Deadlock](#deadlock)

#### 13. [Semaphores](#semaphores)

#### 14. [Race condition](#race-condition)

#### 15. [Blocking queue](#blocking-queue)

#### 15. [Futures object](#futures-object)

#### 16. [deadlock, livelock & thread starvation](#deadlock-livelock-&-thread-starvation)

# Multithread enviroment

a. What kind of common problems, which usually comes while doing concurrent operation you have faced in multi-threading
environment? How did you resolve it?

Common problems encountered in a multi-threading environment during concurrent operations include:

**Race Conditions**: This occurs when multiple threads attempt to access and modify shared data simultaneously, and the
final result depends on the unpredictable order of execution. This can lead to incorrect or inconsistent data.

*Resolution*: Employ synchronization mechanisms such as mutexes, semaphores, or locks to ensure that only one thread can
access the critical section (the shared data) at a time. For example, in Java, the synchronized keyword or *
*ReentrantLock** can be used. **ReentrantLock** in Java is a concrete implementation of the Lock interface within the
java.util.concurrent.locks package. It provides a more flexible and powerful mechanism for thread synchronization
compared to the synchronized keyword.

*Key characteristics of ReentrantLock:*

**Reentrant Behavior**: A thread that already holds a ReentrantLock can acquire it again without causing a deadlock.
This is because the lock maintains a "hold count" for the owning thread, incrementing it with each acquisition and
decrementing it with each release. The lock is only truly released when the hold count reaches zero.
Explicit Locking: Unlike synchronized which uses implicit lock acquisition and release, ReentrantLock requires explicit
calls to lock() to acquire the lock and unlock() to release it. It's crucial to place unlock() within a finally block to
ensure the lock is always released, even if exceptions occur.

**Fairness Policy**: ReentrantLock offers the option to create a fair lock (using new ReentrantLock(true)). In a fair
lock, threads waiting to acquire the lock are granted access in the order they requested it, preventing "thread
starvation." A non-fair lock (the default) allows for higher throughput but doesn't guarantee the order of acquisition.

**Interruptible Locking**: Threads waiting for a ReentrantLock can be interrupted using lockInterruptibly(), allowing
for more responsive and robust handling of long-waiting threads.

**TryLock**: The tryLock() method allows a thread to attempt to acquire the lock without blocking indefinitely. It
returns true if the lock is acquired successfully and false otherwise. Overloaded versions of tryLock() allow specifying
a timeout for the acquisition attempt.

Example Usage:

```Java

import java.util.concurrent.locks.ReentrantLock;

public class SharedResource {
    private final ReentrantLock lock = new ReentrantLock();
    private int counter = 0;

    public void increment() {
        lock.lock(); // Acquire the lock
        try {
            counter++;
            System.out.println(Thread.currentThread().getName() + " incremented counter to: " + counter);
        } finally {
            lock.unlock(); // Release the lock in a finally block
        }
    }

    public int getCounter() {
        return counter;
    }
}
```

**Deadlocks**: A deadlock arises when two or more threads are blocked indefinitely, each waiting for a resource held by
another thread in the same cycle. This can cause the application to freeze.

*Resolution*: Implement deadlock prevention strategies, such as enforcing a strict order of resource acquisition, using
timeouts for acquiring locks, or employing deadlock detection algorithms. Carefully design resource allocation to avoid
circular dependencies.

**Livelocks**: Similar to deadlocks, threads in a livelock continuously change their state in response to other threads,
but no actual progress is made. They are not blocked but are stuck in a loop of futile actions.

*Resolution*: Introduce random backoff mechanisms or prioritize threads to break the cycle of repeated, unproductive
actions.

**Starvation**: Starvation occurs when a thread is repeatedly denied access to a shared resource, even though the
resource becomes available, because other threads consistently acquire it.

*Resolution*: Implement fair scheduling algorithms for resource access, such as using fair locks or priority queues, to
ensure that all threads eventually get their turn.

**Data Inconsistency (Visibility Issues)**: In some cases, changes made by one thread to shared data might not be
immediately visible to other threads due to processor caching or compiler optimizations.

*Resolution*: Use volatile keywords for variables that are frequently read and written by multiple threads to ensure
that changes are always read from main memory. Alternatively, use synchronization primitives that establish a
happens-before relationship, guaranteeing memory visibility.

**Performance Overheads**: Excessive use of synchronization or fine-grained locking can introduce significant overhead,
negating the performance benefits of multithreading.

*Resolution*: Optimize synchronization by using concurrent data structures (e.g., ConcurrentHashMap), reducing the scope
of synchronized blocks, and considering lock-free algorithms where appropriate. Profile the application to identify
performance bottlenecks.

# Thread-safe code

Here are some guidelines and best practices for writing thread-safe code:

**Prefer Immutability**: Design objects to be immutable whenever possible. Immutable objects, whose state cannot be
changed after creation, inherently eliminate race conditions and do not require synchronization mechanisms.

**Minimize Shared Mutable State**: Limit the amount of data that is shared and can be modified by multiple threads.
Encapsulate shared mutable data and provide controlled access to it.

**Use Concurrent Collections**: Leverage pre-existing thread-safe concurrent data structures provided by your language
or framework (e.g., ConcurrentHashMap, CopyOnWriteArrayList in Java). These collections handle synchronization
internally and are often optimized for concurrent access.

**Synchronize Access to Shared Mutable State**: When shared mutable state is unavoidable, use appropriate
synchronization mechanisms (e.g., locks, mutexes, semaphores) to protect critical sections of code that access or modify
this state.
Keep Lock Scopes Small: Acquire and release locks for the shortest possible duration. This reduces contention and
improves concurrency. Avoid holding locks across long-running operations or I/O calls.

**Avoid Nested Locks**: Taking multiple locks in different orders across different threads can easily lead to deadlocks.
If multiple locks are necessary, establish a strict, consistent ordering for acquiring them across all threads.

**Use Thread-Local Variables**: For data that needs to be unique to each thread, use thread-local storage. This avoids
sharing and eliminates the need for synchronization for that specific data.

**Leverage Higher-Level Concurrency Constructs**: Utilize higher-level abstractions like thread pools, ExecutorService,
or asynchronous programming models (async/await) to manage threads and concurrency more effectively, often abstracting
away low-level synchronization details.

**Test Thoroughly Under Load**: Concurrency bugs can be subtle and often only manifest under specific load conditions.
Rigorously test your multithreaded code with stress tests and concurrency testing tools to uncover potential issues.

**Document Locking Strategy**: Clearly document the synchronization mechanisms used, the shared resources they protect,
and any established locking order to aid in maintenance and prevent future concurrency bugs.

# Runnable vs Callable

Runnable and Callable in Java are interfaces for async tasks, but the key difference is that Runnable's run() method
returns void and can't throw checked exceptions, while Callable's call() method returns a generic result and can throw
exceptions, accessed via a Future object for retrieving the value or handling errors, making Callable better for tasks
needing a return value.

**Runnable**

Method: void run()

Returns: Nothing (void)

Exceptions: Cannot throw checked exceptions (must handle internally)

Package: java.lang

Use Case: Simple tasks where you just need execution, not a result (e.g., printing a message).

Callable
Method: <V> V call()
Returns: A generic value (e.g., Integer, String)
Exceptions: Can throw checked exceptions (e.g., Exception)
Package: java.util.concurrent
Use Case: Tasks that compute and return a value, or need exception handling for the result (e.g., a calculation,
database query).
Key Takeaway
Use Runnable for fire-and-forget tasks; use Callable when you need the task to produce a result or signal an error back
to the main thread, typically using an ExecutorService to submit it and a Future to get the outcome.

# UncaughtExceptionHandler

In Java, an unhandled exception in a thread can be managed using UncaughtExceptionHandler. This mechanism allows for
custom handling of exceptions that are not caught within the thread's run() method.
Here's how to implement it: Create a custom UncaughtExceptionHandler.
Implement the Thread.UncaughtExceptionHandler interface and define the uncaughtException(Thread t, Throwable e) method.
This method will be invoked when an uncaught exception occurs in the thread t.

```Java

class MyUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {
    @Override
    public void uncaughtException(Thread t, Throwable e) {
        System.err.println("Caught unhandled exception in thread " + t.getName() + ": " + e.getMessage());
        // Log the error, perform cleanup, or take other appropriate actions
    }
}
```

Set the handler for a specific thread:
You can set a custom handler for an individual Thread instance using thread.setUncaughtExceptionHandler().

```Java

Thread myThread = new Thread(() -> {
    // Code that might throw an uncaught exception
    int result = 10 / 0; // This will cause an ArithmeticException
});
    myThread.

setUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
        myThread.

start();
```

Set a default handler for all threads:
For a more global approach, you can set a default uncaught exception handler for all newly created threads in your
application using Thread.setDefaultUncaughtExceptionHandler(). This handler will be used if no specific handler is set
for a particular thread.

```Java

Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());

Thread anotherThread = new Thread(() -> {
    // Code that might throw an uncaught exception
    String str = null;
    str.length(); // This will cause a NullPointerException
});
    anotherThread.

start();
```

Key Considerations:

**Logging**: Always log the exception details (stack trace, message) for debugging and analysis.

**Resource Cleanup**: Use the handler to perform any necessary resource cleanup, especially if the unhandled exception
could leave resources in an inconsistent state.

**Application Stability**: Decide whether the unhandled exception should terminate the application or if the handler can
gracefully recover.
Error Reporting: Consider integrating with error reporting tools to automatically track and manage unhandled exceptions
in production environments.

# Thread-scheduling

In Java, tasks can be scheduled using built-in utilities like the ScheduledExecutorService and Timer, or with powerful
external libraries and frameworks such as Spring's @Scheduled annotation and the Quartz scheduler.

The Java Virtual Machine (JVM) employs a preemptive, priority-based scheduling algorithm for its threads.

Here's a breakdown:

**Priority-Based**: Each Java thread has an assigned priority, an integer value between Thread.MIN_PRIORITY and
Thread.MAX_PRIORITY. The thread scheduler prioritizes runnable threads with higher priority for execution.

**Preemptive**: If a higher-priority thread becomes runnable while a lower-priority thread is executing, the JVM can
preempt (interrupt) the lower-priority thread to allow the higher-priority thread to run.

**Round-Robin (for equal priority)**: If multiple threads have the same highest priority and are in a runnable state,
the scheduler typically uses a round-robin approach to give each of them a turn, often with time-slicing on systems that
support it.

**Inheritance**: When a new thread is created, it inherits the priority of its parent thread. This priority can be
modified using the setPriority() method.

**Yielding**: Threads can voluntarily give up their CPU time to other threads of the same or higher priority using the
Thread.yield() method.

It is important to note that while Java specifies this priority-based scheduling, the actual implementation and behavior
can be influenced by the underlying operating system's thread scheduling mechanisms, as Java threads are typically
mapped to operating system threads.

# Thread execution

a. You have thread T1, T2, and T3, how will you ensure that thread T2 run after T1 and thread T3 run after T2?
a. Apart from Thread class instance join (), what are the other ways to do that? How join method is able to achieve it
internally?

To ensure that thread T2 runs after T1 and thread T3 runs after T2 in Java, the join() method of the Thread class can be
utilized. This method allows one thread to wait for the completion of another thread before proceeding.

*Here's how to implement this sequential execution:*

**Create the threads**: Instantiate Thread objects for T1, T2, and T3. Each thread should encapsulate the task it needs
to perform (e.g., by implementing the Runnable interface).

**Start T1**: Begin the execution of thread T1 by calling its start() method.

**Wait for T1 to finish**: In the main thread or the thread that initiated T1, call T1.join(). This will cause the
current thread to pause its execution until T1 completes its run() method.

**Start T2**: Once T1 has finished (i.e., T1.join() returns), start thread T2 by calling T2.start().

**Wait for T2 to finish**: Similarly, call T2.join() to ensure that T2 completes before T3 begins.

**Start T3**: After T2 has finished, start thread T3 by calling T3.start().
This sequence of start() and join() calls guarantees the desired execution order: T1 will complete before T2 starts, and
T2 will complete before T3 starts.

```Java

public class SequentialThreadExecution {

    public static void main(String[] args) {
        Thread t1 = new Thread(() -> {
            System.out.println("T1 executed");
        }, "T1");

        Thread t2 = new Thread(() -> {
            System.out.println("T2 executed");
        }, "T2");

        Thread t3 = new Thread(() -> {
            System.out.println("T3 executed");
        }, "T3");

        try {
            t1.start(); // Start T1
            t1.join();  // Wait for T1 to finish

            t2.start(); // Start T2
            t2.join();  // Wait for T2 to finish

            t3.start(); // Start T3
            t3.join();  // Wait for T3 to finish

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.err.println("Thread interrupted: " + e.getMessage());
        }

        System.out.println("All threads finished.");
    }
}
```

**Alternatives to Thread.join() for Thread Synchronization**

While Thread.join() is a direct way to wait for a thread's completion, other mechanisms in Java can achieve similar
synchronization or coordination:

**CompletableFuture**: This provides a more modern and flexible approach to asynchronous programming and task
coordination. You can chain tasks, combine results, and handle errors without explicitly blocking threads. You can still
use CompletableFuture.join() or get() to block if necessary, but the emphasis is on non-blocking composition.

**ExecutorService and Future**: When using ExecutorService to manage threads, submitting tasks returns Future objects.
You can call Future.get() to wait for the task's completion and retrieve its result. This blocks the calling thread
until the task finishes.

**CountDownLatch**: This allows one or more threads to wait until a set of operations being performed in other threads
completes. You initialize it with a count, and threads performing work decrement the count. The waiting thread calls
await(), which blocks until the count reaches zero.

**CyclicBarrier**: This enables multiple threads to wait for each other at a common "barrier point" before proceeding.
It's useful for scenarios where a group of threads needs to synchronize before continuing to the next phase of a
computation.

**Phaser**: A more flexible synchronization barrier than CountDownLatch or CyclicBarrier, Phaser allows for dynamic
registration and deregistration of parties, and it supports multiple phases of synchronization.

**Internal Mechanism of Thread.join()**

The Thread.join() method's internal implementation relies on the Object.wait() and Object.notifyAll() mechanisms.

*When threadA.join() is called from threadB:*

threadB acquires the lock on threadA's monitor (every object in Java has an intrinsic lock associated with it).

threadB then calls threadA.wait(). This releases the lock on threadA and puts threadB into a waiting state.

When threadA completes its execution (i.e., its run() method finishes), the Java Virtual Machine (JVM) internally calls
threadA.notifyAll().

This notifyAll() wakes up any threads waiting on threadA's monitor, including threadB.

threadB then reacquires the lock on threadA and resumes its execution.

Essentially, join() leverages the fundamental wait() and notifyAll() methods to achieve thread synchronization, ensuring
that the calling thread pauses until the target thread has finished its work.

## If you have to implement a high-performance cache which allows multiple readers but the single writer to keep the integrity how will you implement it?

Implementing a high-performance cache in Java that supports multiple readers and a single writer while maintaining data
integrity typically involves using a ReadWriteLock or an atomic reference to a new cache instance.

**1. Using java.util.concurrent.locks.ReadWriteLock:**

This approach offers fine-grained control over read and write access.

```Java

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class HighPerformanceCache<K, V> {
    private final Map<K, V> cache = new HashMap<>();
    private final ReadWriteLock lock = new ReentrantReadWriteLock();

    public V get(K key) {
        lock.readLock().lock(); // Acquire read lock
        try {
            return cache.get(key);
        } finally {
            lock.readLock().unlock(); // Release read lock
        }
    }

    public void put(K key, V value) {
        lock.writeLock().lock(); // Acquire write lock
        try {
            cache.put(key, value);
        } finally {
            lock.writeLock().unlock(); // Release write lock
        }
    }

    public void remove(K key) {
        lock.writeLock().lock(); // Acquire write lock
        try {
            cache.remove(key);
        } finally {
            lock.writeLock().unlock(); // Release write lock
        }
    }
}
```

Read Operations: Multiple threads can acquire the readLock() concurrently, allowing high-performance read access.

Write Operations: Only one thread can acquire the writeLock() at a time, ensuring data integrity during modifications.
All readers are blocked while a write lock is held.

**2. Using an Atomic Reference to a New Cache Instance (Copy-on-Write):**

This approach avoids locking during read operations entirely, but incurs a higher cost for writes as a new cache
instance is created.

```Java

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

public class HighPerformanceAtomicCache<K, V> {
    private final AtomicReference<Map<K, V>> cacheRef;

    public HighPerformanceAtomicCache() {
        cacheRef = new AtomicReference<>(Collections.unmodifiableMap(new HashMap<>()));
    }

    public V get(K key) {
        return cacheRef.get().get(key); // Read from the current immutable map
    }

    public void put(K key, V value) {
        while (true) {
            Map<K, V> oldCache = cacheRef.get();
            Map<K, V> newCache = new HashMap<>(oldCache); // Create a mutable copy
            newCache.put(key, value);
            if (cacheRef.compareAndSet(oldCache, Collections.unmodifiableMap(newCache))) { // Atomically swap
                return;
            }
        }
    }

    public void remove(K key) {
        while (true) {
            Map<K, V> oldCache = cacheRef.get();
            Map<K, V> newCache = new HashMap<>(oldCache); // Create a mutable copy
            newCache.remove(key);
            if (cacheRef.compareAndSet(oldCache, Collections.unmodifiableMap(newCache))) { // Atomically swap
                return;
            }
        }
    }
}
```

Read Operations: Readers always access an immutable Map, eliminating the need for explicit locks during reads.

Write Operations: A new HashMap is created, populated with the old data and the new change, and then atomically swapped
using compareAndSet. This ensures consistency but can be more expensive for frequent writes due to object creation and
copying.
Choosing the Right Implementation:

ReadWriteLock: Suitable when write operations are relatively infrequent compared to reads, and the overhead of acquiring
and releasing locks is acceptable.

Atomic Reference (Copy-on-Write): Ideal for scenarios with extremely high read concurrency and less frequent writes,
where minimizing read latency is paramount. The cost of copying the entire map on each write needs to be considered.

# Thread life cycle

a. Thread life cycle with difference between wait, sleep and yield methods.

Java Thread Life Cycle
A Java thread progresses through several states during its lifetime:
New: A thread is in the New state when it is created but has not yet started execution (i.e., start() method has not
been called).
Runnable: After start() is called, the thread enters the Runnable state. It is now eligible to be run by the thread
scheduler, but it might not be actively executing yet.
Blocked: A thread enters the Blocked state when it is temporarily unable to run because it is waiting to acquire a
monitor lock.
Waiting: A thread enters the Waiting state when it calls wait(), join(), or LockSupport.park(). It remains in this state
until another thread explicitly wakes it up using notify(), notifyAll(), or LockSupport.unpark().
Timed Waiting: Similar to Waiting, but with a specified timeout. A thread enters this state when it calls methods like
sleep(long millis), wait(long millis), join(long millis), or LockSupport.parkNanos(). It will either wake up when the
timeout expires or when explicitly notified.
Terminated: The thread enters the Terminated state after its run() method completes or when it exits due to an uncaught
exception.
Differences between wait(), sleep(), and yield()
wait():
Belongs to Object class: wait() is a method of the Object class, meaning any object can be used for waiting and
notification.
Releases monitor lock: When a thread calls wait(), it releases the monitor lock it holds on the object. This allows
other threads to acquire the lock and potentially modify the shared resource.
Requires synchronized block: wait() must be called within a synchronized block or method, as it interacts with object
monitors.
Purpose: Used for inter-thread communication, where a thread waits for a specific condition to become true, and another
thread notifies it when the condition is met.
sleep():
Belongs to Thread class: sleep() is a static method of the Thread class.
Does not release monitor lock: When a thread calls sleep(), it does not release any monitor locks it holds.
Can be called anywhere: sleep() can be called from any part of the code, not necessarily within a synchronized block.
Purpose: Used to pause the execution of the current thread for a specified duration, typically for introducing delays or
controlling execution timing.
yield():
Belongs to Thread class: yield() is a static method of the Thread class.
Does not release monitor lock: Like sleep(), yield() does not release any monitor locks.
Hint to the scheduler: yield() is a hint to the thread scheduler that the current thread is willing to relinquish its
CPU time to other threads of the same or higher priority. The scheduler may or may not act upon this hint.
Purpose: Primarily used for performance tuning or in situations where a thread is performing a busy-wait and wants to
give other threads a chance to run. Its behavior is highly dependent on the JVM and operating system's thread scheduler.

# fork/join

a. Describe the purpose and use-cases of the fork/join framework.

The Java Fork/Join Framework, introduced in Java 7, is a specialized framework designed for efficiently executing tasks
that follow the "divide and conquer" paradigm. Its primary purpose is to leverage the power of multi-core processors by
breaking down large, computationally intensive problems into smaller, independent subtasks that can be processed in
parallel.
Purpose:
Parallelism: To efficiently utilize multi-core processors by distributing workloads across available CPU cores.
Divide and Conquer: To provide a structured way to implement algorithms that recursively break down problems into
subproblems.
Work Stealing: To maximize CPU utilization by enabling idle worker threads to "steal" tasks from busy threads, ensuring
continuous processing.
Simplified Concurrency: To abstract away much of the complexity of thread management, allowing developers to focus on
the problem logic.
Use Cases:
The Fork/Join Framework is particularly well-suited for problems that can be naturally expressed as recursive, divisible
tasks. Common use cases include:
Large Data Processing:
Summing or searching large arrays: Dividing the array into segments and processing each segment in parallel.
Image processing: Applying filters or transformations to different parts of an image concurrently.
Recursive Algorithms:
Parallel sorting algorithms: Implementing parallel versions of algorithms like Merge Sort or Quick Sort.
Calculating Fibonacci numbers: Recursively computing parts of the sequence in parallel.
Graph Traversal:
Parallel breadth-first search or depth-first search: Exploring different branches of a graph concurrently.
Scientific Computing:
Matrix operations: Performing parallel computations on elements or sub-matrices.
Simulations: Dividing simulation steps or scenarios for parallel execution.
Example (Conceptual):
Imagine calculating the sum of a billion numbers in an array. Using the Fork/Join Framework, you could:
Fork: Create a RecursiveTask that, if the array segment is too large, splits it into two halves and recursively calls
itself for each half.
Compute: If the segment is small enough (base case), directly calculate the sum of that segment.
Join: Combine the results from the two halves by summing their individual sums, effectively merging the sub-results back
up the call stack.
This process allows different parts of the array to be processed concurrently on different cores, significantly speeding
up the overall calculation.

# Thread Dumps

Generating and analyzing Java thread dumps is crucial for diagnosing performance issues, deadlocks, and other
concurrency-related problems in Java applications.

1. Generating Thread Dumps:
   Several methods can be used to generate thread dumps:
   jstack (Recommended): This JDK tool is the most common way.
   Código

   jstack -l <pid> > threaddump.log
   Replace <pid> with the process ID of your Java application. You can find the PID using jps (another JDK tool) or your
   operating system's task manager. The -l option provides more detailed lock information.
   kill -3 <pid> (Unix/Linux): Sends a SIGQUIT signal to the JVM, which prints the thread dump to standard output (
   usually the application's log file).
   Ctrl + Break (Windows): For console-based Java applications, pressing Ctrl + Break generates a thread dump in the
   console.
   JVisualVM/JConsole: These GUI tools provide a visual way to generate thread dumps and offer some basic analysis
   features.
   jcmd: Another JDK utility for diagnostic commands.
   Código

   jcmd <pid> Thread.print > threaddump.log
   Application Servers and APM Tools: Many application servers (like Tomcat, WebLogic) and Application Performance
   Monitoring (APM) tools (like AppDynamics, Dynatrace) have built-in functionalities to capture thread dumps.
2. Analyzing Thread Dumps:
   Once generated, thread dumps can be analyzed using various approaches:
   Manual Inspection: Open the threaddump.log file in a text editor. Look for:
   Thread States: Identify threads that are RUNNABLE, BLOCKED, WAITING, or TIMED_WAITING.
   Stack Traces: Examine the call stacks of individual threads to understand what code they are executing and where they
   might be stuck.
   Synchronization Issues: Look for BLOCKED or WAITING threads, especially those waiting to acquire locks. This can
   indicate contention or potential deadlocks.
   Deadlocks: Search for the "Found one Java-level deadlock" message in the dump, which jstack can often detect.
   High CPU Usage: Focus on RUNNABLE threads, especially if they are consistently executing CPU-intensive tasks.
   Thread Dump Analyzer Tools: Dedicated tools can simplify analysis, especially for large or complex dumps:
   fastThread: A popular online tool that analyzes thread dumps and provides reports.
   IBM Thread and Monitor Dump Analyzer (TDMA): Useful for IBM JVMs but offers some compatibility with other JVMs.
   JVisualVM/JConsole: Provide basic graphical analysis.
   APM Tools: Offer advanced analysis features and integrate with other performance metrics.
   Correlate with Other Metrics: Combine thread dump analysis with other performance data (CPU usage, memory usage,
   garbage collection logs) for a holistic view of the application's health.
   Tips for Effective Analysis:
   Take Multiple Dumps: Capture several thread dumps at short intervals (e.g., 5-10 seconds apart) to observe changes in
   thread states and identify recurring patterns.
   Name Threads Appropriately: In your application code, give meaningful names to custom threads for easier
   identification during analysis.
   Focus on Problematic Threads: Prioritize BLOCKED, WAITING, or high-CPU RUNNABLE threads related to the observed
   performance issue.

## Difference between object lock and class lock?

In Java, both object locks and class locks are mechanisms for achieving thread synchronization, but they operate at
different levels of granularity.
Object Lock:
Scope: An object lock is associated with a specific instance of a class. Every object in Java has its own unique
intrinsic lock.
Purpose: It's used to synchronize access to non-static (instance) methods or blocks of code within an object. This
ensures that only one thread can execute the synchronized code on a particular object instance at any given time.
Implementation: Achieved using the synchronized keyword on a non-static method or by synchronizing on a specific object
reference within a synchronized block.
Java

    class MyObject {
        private int instanceData;

        public synchronized void modifyInstanceData() {
            // Only one thread can execute this method on a specific MyObject instance at a time
            instanceData++;
        }

        public void anotherMethod() {
            synchronized (this) { // Synchronizing on the current object
                // Only one thread can execute this block on a specific MyObject instance at a time
                instanceData--;
            }
        }
    }

Class Lock:
Scope: A class lock is associated with the Class object itself, representing the entire class definition. There is only
one Class object per class in the Java Virtual Machine.
Purpose: It's used to synchronize access to static methods or static blocks of code. This ensures that only one thread
can execute the synchronized static code for that class, regardless of which instance (or no instance) is involved.
Implementation: Achieved using the synchronized keyword on a static method or by synchronizing on the Class object (
e.g., MyClass.class) within a synchronized block.
Java

    class MyClass {
        private static int staticData;

        public static synchronized void modifyStaticData() {
            // Only one thread can execute this static method for MyClass at a time
            staticData++;
        }

        public void someMethod() {
            synchronized (MyClass.class) { // Synchronizing on the Class object
                // Only one thread can execute this block for MyClass at a time
                staticData--;
            }
        }
    }

Key Differences Summarized:
Feature
Object Lock
Class Lock
Scope
Specific object instance
Entire class
Target
Non-static (instance) methods/data
Static methods/data
Mechanism
synchronized on non-static methods or this
synchronized on static methods or ClassName.class
Concurrency
Multiple threads can access synchronized methods on different objects concurrently.

## What will be your design approach, if you have to design your own custom thread pool?

Designing a custom thread pool in Java involves several key considerations to ensure efficiency, resource management,
and proper task handling. The design approach would typically encompass the following:
Core Components:
Worker Threads: A fixed or dynamic number of threads that will execute tasks. These threads would typically loop,
waiting for tasks from a queue.
Task Queue: A BlockingQueue (e.g., LinkedBlockingQueue, ArrayBlockingQueue) to store submitted tasks (Runnable or
Callable). The choice of queue depends on whether a bounded or unbounded queue is desired, and its capacity.
Task Submission Mechanism: A method to submit tasks to the thread pool, which adds them to the task queue.
Lifecycle Management: Methods to start, shut down, and gracefully terminate the thread pool.
Thread Pool Parameters:
Core Pool Size: The minimum number of threads to keep alive in the pool, even if idle.
Maximum Pool Size: The maximum number of threads allowed in the pool. This is relevant when using a bounded queue and a
RejectedExecutionHandler.
Keep-Alive Time: The time duration for which excess idle threads (beyond the core pool size) will wait for new tasks
before terminating.
Thread Factory: A custom ThreadFactory to create threads with specific names, priorities, or daemon status for easier
debugging and management.
Task Handling and Execution:
Worker Thread Logic: Each worker thread continuously dequeues tasks from the BlockingQueue and executes them. Robust
exception handling within the worker thread is crucial to prevent thread termination on task-specific errors.
Task Type: Support for both Runnable (for fire-and-forget tasks) and Callable (for tasks returning a result) would be
beneficial, potentially returning Future objects for Callable tasks.
Rejection Policy (for Bounded Queues):
When the task queue is full and the maximum pool size is reached, a RejectedExecutionHandler determines how to handle
new task submissions. Options include:
AbortPolicy: Throws a RejectedExecutionException.
CallerRunsPolicy: Executes the rejected task in the calling thread.
DiscardPolicy: Silently discards the rejected task.
DiscardOldestPolicy: Discards the oldest unexecuted task in the queue and retries the current submission.
Custom Policy: Implement a custom RejectedExecutionHandler for specific application requirements, such as logging,
retries, or alternative processing.
Shutdown Mechanism:
Graceful Shutdown: Allow currently executing tasks to complete and then process remaining tasks in the queue before
terminating worker threads.
Immediate Shutdown: Attempt to stop all executing tasks and clear the task queue, terminating threads immediately.
Monitoring and Management:
Provide mechanisms to monitor the pool's state, such as the number of active threads, queue size, and completed task
count, for performance analysis and debugging.
This comprehensive approach allows for the creation of a tailored thread pool that addresses specific application needs
for concurrency management and resource optimization.

## What will be your approach to handle uncaught runtime exception generated in run method?

Handling uncaught RuntimeException instances generated in a run method in Java, especially within a Thread, involves
using the Thread.UncaughtExceptionHandler interface.
Here is the approach:
Implement Thread.UncaughtExceptionHandler: Create a class that implements this interface and override the
uncaughtException(Thread t, Throwable e) method. This method will be invoked when a thread terminates due to an uncaught
exception.
Java

    class MyUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {
        @Override
        public void uncaughtException(Thread t, Throwable e) {
            System.err.println("Uncaught exception in thread " + t.getName() + ": " + e.getMessage());
            e.printStackTrace(); // Log the stack trace
            // Perform any necessary cleanup or error reporting
        }
    }

Set the UncaughtExceptionHandler:
For a specific thread: Set the handler on the individual Thread object using thread.setUncaughtExceptionHandler(new
MyUncaughtExceptionHandler()); before starting the thread.
Globally for all threads: Set a default handler for all newly created threads that don't have a specific handler set
using Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());. This should be done early in the
application's lifecycle.
Java

    // Example for a specific thread
    Thread myThread = new Thread(() -> {
        throw new RuntimeException("Something went wrong in my thread!");
    });
    myThread.setUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
    myThread.start();

    // Example for a default handler
    Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
    Thread anotherThread = new Thread(() -> {
        throw new RuntimeException("Another error in another thread!");
    });
    anotherThread.start();

Explanation:
When a RuntimeException is thrown within a Thread's run method and not caught by a try-catch block within that method,
the Java Virtual Machine (JVM) will look for an UncaughtExceptionHandler.
It first checks if a handler is explicitly set on the Thread object.
If not, it checks the Thread's ThreadGroup for a handler.
Finally, if no specific handler is found, it uses the default handler set via
Thread.setDefaultUncaughtExceptionHandler().
The uncaughtException method in your custom handler will then be invoked, allowing you to log the exception, perform
cleanup, or implement other error-handling logic before the thread terminates.

## What is CountDownLatch & CyclicBarrier? If you have to implement it by your own, what will be your approach?

CountDownLatch is a one-time barrier where one or more threads wait for a specific number of operations to complete.
CyclicBarrier is a reusable barrier where a group of threads waits for each other to reach a common synchronization
point before all of them can proceed. Implementing them would involve using a shared counter protected by a lock, with
await() and countdown() methods for the latch, and a similar pattern with a reset for the barrier to make it cyclic.
CountDownLatch
What it is: A synchronization aid that allows one or more threads to wait until a set of operations, performed in other
threads, completes.
Use case: When a thread needs to wait for a specific number of tasks to finish. For example, a main thread waiting for
several worker threads to complete their initialization tasks before the application can proceed.
Key difference: It's a "one-shot" mechanism; once the count reaches zero, the latch cannot be reset and reused.
CyclicBarrier
What it is: A synchronization aid where a group of threads must all wait for each other to reach a common barrier point.
Use case: When multiple threads are involved in an iterative process and need to synchronize at the end of each
iteration. For example, in a game where all players must reach a certain point before the next round begins.
Key difference: It is reusable. Once all waiting threads are released, the barrier can be reset and used again for a new
phase.
Implementation approach
Custom CountDownLatch
Data structure: A private volatile int count variable and a ReentrantLock to ensure thread-safe access to the count.
Constructor: CustomCountDownLatch(int initialCount) initializes count to initialCount.
await() method:
Acquire the lock.
Use a while loop to check if count is greater than zero.
If it is, use lock.newCondition().await() to make the thread wait.
If the count is zero, release the lock and exit.
countDown() method:
Acquire the lock.
Decrement count.
If count becomes zero, signal all waiting threads using lock.newCondition().signalAll().
Release the lock.
Custom CyclicBarrier
Data structure: A volatile int parties (the number of threads to wait for), a volatile int count (current number of
threads at the barrier), and a ReentrantLock.
Constructor: CustomCyclicBarrier(int parties) initializes parties and count.
await() method:
Acquire the lock.
Increment the count.
If count equals parties, reset count to 0 and signalAll() all waiting threads.
If count is less than parties, await() the condition, and if signaled, release the lock.
reset() method:
Acquire the lock.
Reset count to 0.
Release the lock.

# Difference between synchronized and ReentrantLock in java?

synchronized and ReentrantLock are both mechanisms in Java for achieving thread synchronization and protecting shared
resources from race conditions. They differ in their level of control, flexibility, and features.

1. Implicit vs. Explicit Locking:
   synchronized: This is an implicit locking mechanism, meaning the JVM automatically handles lock acquisition and
   release. When a thread enters a synchronized block or method, it acquires the intrinsic lock of the object (or class,
   for static methods), and the lock is automatically released when the block/method exits (either normally or via an
   exception).
   ReentrantLock: This offers explicit locking. You must manually acquire the lock using lock() and release it using
   unlock() within a try-finally block to ensure proper release even in case of exceptions.
2. Flexibility and Features:
   synchronized: Provides basic synchronization. It lacks features like timed waits, interruptible lock acquisition, and
   fairness policies.
   ReentrantLock: Offers greater flexibility and advanced features:
   tryLock(): Attempts to acquire the lock without blocking, returning true if successful and false otherwise. This
   allows for non-blocking lock acquisition.
   tryLock(long timeout, TimeUnit unit): Attempts to acquire the lock within a specified timeout period, allowing for
   timed waits.
   lockInterruptibly(): Acquires the lock but allows the waiting thread to be interrupted.
   Fairness: Can be configured to be "fair," meaning the longest-waiting thread is granted the lock next, preventing
   potential thread starvation. synchronized does not offer fairness guarantees.
3. Reentrancy:
   Both synchronized and ReentrantLock are reentrant. This means a thread that already holds a lock can acquire the same
   lock again without deadlocking itself. The lock maintains a "hold count," which is incremented upon re-acquisition
   and decremented upon release. The lock is fully released only when the hold count reaches zero.
4. Performance:
   For simple, low-contention scenarios, synchronized can be optimized by the JVM and perform well.
   In high-contention scenarios, or when advanced features are required, ReentrantLock can offer better performance and
   more control.
   In summary:
   Use synchronized for simple, straightforward synchronization needs where automatic lock management is desired and
   advanced features like timed waits or interruptible lock acquisition are not required.
   Use ReentrantLock when you need finer-grained control over lock acquisition and release, require advanced features
   like timed waits, interruptible locking, or fairness, or are dealing with complex, high-contention concurrency
   scenarios.

# Executor framework

a. What is executor framework in java? Explain the usage of Executor, ExecutorService inside that. Explain thread pool
configuration in detail like CorePoolSize, MaximumPoolSize and KeepAliveTime.

The Executor Framework in Java provides a high-level API for managing and executing asynchronous tasks, abstracting away
the complexities of manual thread management.
Executor and ExecutorService:
Executor: This is the base interface in the framework. It defines a single method, execute(Runnable command), which
takes a Runnable task and executes it. The Executor interface decouples task submission from task execution, allowing
you to submit tasks without directly interacting with threads.
ExecutorService: This interface extends Executor and provides more advanced features for managing the lifecycle of tasks
and the thread pool. Key methods include:
submit(Callable<T> task) or submit(Runnable task): Submits a task for execution and returns a Future representing the
result of the task.
shutdown(): Initiates an orderly shutdown, allowing previously submitted tasks to complete but rejecting new tasks.
shutdownNow(): Attempts to stop all actively executing tasks and halts the processing of waiting tasks.
awaitTermination(long timeout, TimeUnit unit): Blocks until all tasks have completed execution after a shutdown request,
or the timeout occurs, or the current thread is interrupted.
Thread Pool Configuration in ThreadPoolExecutor:
ThreadPoolExecutor is a concrete implementation of ExecutorService that allows for fine-grained control over the thread
pool. Its constructor takes several parameters for configuration:
corePoolSize: This is the number of threads that are always kept alive in the pool, even if they are idle. When a new
task arrives and there are fewer than corePoolSize threads, a new thread is created to handle the task.
maximumPoolSize: This represents the maximum number of threads that the pool can contain. If all corePoolSize threads
are busy and the task queue is full, new threads (up to maximumPoolSize) are created to handle incoming tasks.
keepAliveTime: This specifies the amount of time that idle threads (beyond the corePoolSize) will wait for new tasks
before being terminated. This helps in reclaiming resources when the demand for threads decreases.
unit: This is the TimeUnit for the keepAliveTime argument (e.g., TimeUnit.SECONDS, TimeUnit.MILLISECONDS).
Example Usage:
Java

import java.util.concurrent.*;

public class ExecutorFrameworkExample {
public static void main(String[] args) {
// Create an ExecutorService with a fixed thread pool
ExecutorService executor = Executors.newFixedThreadPool(2);

        // Submit tasks to the executor
        for (int i = 0; i < 5; i++) {
            final int taskId = i;
            executor.submit(() -> {
                System.out.println("Task " + taskId + " executed by thread: " + Thread.currentThread().getName());
                try {
                    Thread.sleep(1000); // Simulate work
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        }

        // Initiate orderly shutdown
        executor.shutdown();
        try {
            // Wait for all tasks to complete
            executor.awaitTermination(5, TimeUnit.SECONDS);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
        System.out.println("ExecutorService shut down.");
    }

}

## What are the available implementations of ExecutorService in the standard library? What are the benefits of using ThreadPoolExecutor implementation of ExecutorService interface?

The ExecutorService interface in Java's standard library has several implementations available, primarily within the
java.util.concurrent package:
Available Implementations of ExecutorService:
ThreadPoolExecutor: This is a general-purpose, configurable thread pool implementation. It manages a pool of worker
threads to execute submitted Runnable or Callable tasks.
ScheduledThreadPoolExecutor: This extends ThreadPoolExecutor and adds the capability to schedule tasks for future
execution, either after a given delay or periodically.
ForkJoinPool: This is a specialized ExecutorService designed for executing ForkJoinTasks, which are suitable for
recursive, divide-and-conquer algorithms. It employs a work-stealing algorithm for efficient thread utilization.
Benefits of using ThreadPoolExecutor:
Using ThreadPoolExecutor offers several advantages:
Reduced Overhead: By reusing a fixed or dynamically managed set of threads, ThreadPoolExecutor avoids the overhead of
creating and destroying threads for each task, improving performance.
Resource Management: It allows control over the number of active threads, preventing resource exhaustion that can occur
from creating too many threads simultaneously.
Task Management: It provides mechanisms for queuing submitted tasks when all threads are busy, ensuring that tasks are
processed eventually.
Configurability: ThreadPoolExecutor offers extensive configuration options, allowing developers to fine-tune its
behavior, including core pool size, maximum pool size, keep-alive time for idle threads, and the type of work queue to
use.
Extensibility: It provides hooks for extending its functionality, enabling custom behavior for tasks and thread
management.
Decoupling Task Submission from Execution: It separates the concerns of submitting tasks from the details of how those
tasks are executed, promoting cleaner and more modular code.

## How static keyword does impacts the thread locks?

In Java, the static keyword significantly impacts thread locks when combined with the synchronized keyword, particularly
in the context of methods.
When a method is declared as static synchronized, the lock acquired by a thread executing that method is on the Class
object of the class containing the method, not on an instance of that class. This means:
Class-level Lock: All static synchronized methods within a given class share the same lock – the lock associated with
the Class object itself.
Mutual Exclusion for Static Methods: If one thread is executing a static synchronized method of a class, no other thread
can execute any other static synchronized method of that same class until the first thread releases the lock.
Independence from Instance Locks: This class-level lock is distinct from any instance-level locks. Therefore, a thread
can be executing a static synchronized method while another thread simultaneously executes a non-static synchronized
method on an instance of that class, as long as they are not contending for the same specific instance lock.
Example:
Java

class MyClass {
public static synchronized void staticMethod1() {
// Critical section for static data
}

    public static synchronized void staticMethod2() {
        // Another critical section for static data
    }

    public synchronized void instanceMethod() {
        // Critical section for instance data
    }

}
In this example:
If staticMethod1() is being executed by Thread A, Thread B cannot execute staticMethod2() until Thread A finishes,
because both contend for the MyClass.class lock.
However, if Thread A is executing staticMethod1(), Thread B can simultaneously execute instanceMethod() on an instance
of MyClass, because instanceMethod() acquires a lock on the MyClass instance, not the Class object.
In summary, static synchronized methods provide a mechanism for thread-safe access to static data and resources by
acquiring a class-level lock, ensuring that only one thread can execute any static synchronized method of that class at
a time.

## deadlock, livelock & thread starvation

In concurrent programming, particularly in Java, deadlock, livelock, and thread starvation are liveness issues that can
prevent an application from making progress.

**Deadlock**

Deadlock occurs when two or more threads are blocked indefinitely, each waiting for the other to release a resource that
it needs. This typically involves a circular dependency where:

Thread A holds Resource 1 and needs Resource 2.
Thread B holds Resource 2 and needs Resource 1.
Neither thread can proceed, and the application effectively freezes.
Java

public class DeadlockExample {
private static final Object resource1 = new Object();
private static final Object resource2 = new Object();

    public static void main(String[] args) {
        Thread thread1 = new Thread(() -> {
            synchronized (resource1) {
                System.out.println("Thread 1: Locked resource 1");
                try { Thread.sleep(100); } catch (InterruptedException e) {}
                synchronized (resource2) {
                    System.out.println("Thread 1: Locked resource 2");
                }
            }
        });

        Thread thread2 = new Thread(() -> {
            synchronized (resource2) {
                System.out.println("Thread 2: Locked resource 2");
                try { Thread.sleep(100); } catch (InterruptedException e) {}
                synchronized (resource1) {
                    System.out.println("Thread 2: Locked resource 1");
                }
            }
        });

        thread1.start();
        thread2.start();
    }

}
Livelock:
Livelock is a situation where two or more threads are actively responding to each other's actions in a way that prevents
any of them from making progress. Unlike deadlock, livelocked threads are not blocked; they are constantly changing
their state in response to the other threads, but no actual work gets done. This is similar to two people trying to pass
each other in a narrow corridor, constantly moving to the side to let the other pass but always ending up in the same
blocking position.
Thread Starvation:
Thread starvation occurs when a thread is repeatedly denied access to a shared resource or CPU time, even though the
resource is available or the thread is ready to run. This can happen due to unfair scheduling, where higher-priority
threads consistently get access to resources, or if a "greedy" thread holds a resource for an extended period,
preventing other threads from acquiring it. The starved thread never gets a chance to execute or complete its task.

# Futures object

a. Completable futures?

In Java, Future and CompletableFuture are used to represent the result of an asynchronous computation.

**1. Future Object**

A Future object represents the result of an asynchronous computation that may not have completed yet. It acts as a
placeholder for a value that will eventually become available.

**Asynchronous Tasks**: When you submit a task to an ExecutorService, it returns a Future object.

**Blocking get()**: To retrieve the result of the computation, you call the get() method on the Future object. This
method is blocking, meaning the calling thread will pause its execution until the asynchronous task completes and its
result is available.

**Limitations**: Future objects offer basic functionality. They do not provide mechanisms for chaining multiple
asynchronous operations, handling exceptions in a non-blocking manner, or manually completing the future.

Example using Future:

```Java

import java.util.concurrent.*;

public class FutureExample {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
        ExecutorService executor = Executors.newSingleThreadExecutor();

        Future<String> future = executor.submit(() -> {
            Thread.sleep(2000); // Simulate a long-running task
            return "Hello from Future!";
        });

        System.out.println("Main thread continues while task runs...");

        String result = future.get(); // This line blocks until the task completes
        System.out.println("Result from Future: " + result);

        executor.shutdown();
    }
}
```

**2. CompletableFuture**

Introduced in Java 8, CompletableFuture significantly enhances the capabilities of Future by implementing both the
Future and CompletionStage interfaces. It provides a rich API for composing, combining, and handling asynchronous
computations in a non-blocking and reactive manner.

**Non-Blocking Operations**: CompletableFuture allows you to define what happens when a computation is done using
methods like thenApply(), thenAccept(), thenRun(), thenCompose(), etc., without blocking the main thread.

**Chaining and Composition**: You can chain multiple asynchronous operations together, where the result of one operation
can be used as input for the next.

**Exception Handling**: CompletableFuture provides methods like exceptionally() and handle() for handling exceptions
that occur during asynchronous computations.

**Manual Completion**: You can manually complete a CompletableFuture using complete() or completeExceptionally(), which
is useful for scenarios where the result is determined outside the asynchronous task itself.

Example using CompletableFuture:

```Java

import java.util.concurrent.CompletableFuture;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadLocalRandom;

public class CompletableFutureExample {
    public static void main(String[] args) {
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
            return "Hello from CompletableFuture!";
        });

        future.thenAccept(result -> System.out.println("Result from CompletableFuture: " + result));

        System.out.println("Main thread continues without blocking...");

        // Keep the main thread alive long enough for the async task to complete
        try {
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
}
```

# Threadlocal

a. For which particular use case one should implement a thread local?

ThreadLocal is a class in Java that provides a way to store data that is local to a specific thread. This means each
thread accessing a ThreadLocal variable gets its own independent copy of that variable, ensuring that changes made by
one thread do not affect the values seen by other threads. It effectively provides thread-specific storage.

**How to Implement ThreadLocal:** To implement ThreadLocal in Java, you create an instance of ThreadLocal and then use
its methods to set and retrieve values for the current thread.

```Java

public class MyThreadLocalExample {

    // Create a ThreadLocal instance to store String values
    private static final ThreadLocal<String> threadLocalValue = new ThreadLocal<>();

    public static void main(String[] args) {
        // Set a value for the main thread
        threadLocalValue.set("Value from Main Thread");
        System.out.println("Main Thread: " + threadLocalValue.get());

        // Create and start a new thread
        Thread workerThread = new Thread(() -> {
            // Set a different value for the worker thread
            threadLocalValue.set("Value from Worker Thread");
            System.out.println("Worker Thread: " + threadLocalValue.get());
        });
        workerThread.start();

        // Wait for the worker thread to complete
        try {
            workerThread.join();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }

        // Access the value again from the main thread (it remains unchanged)
        System.out.println("Main Thread after Worker Thread: " + threadLocalValue.get());
    }
}
```

*In this example:*A ThreadLocal<String> object threadLocalValue is created.
The main thread sets a value using threadLocalValue.set().

A new workerThread is created, and it sets its own distinct value for threadLocalValue.

When the main thread accesses threadLocalValue.get() after the worker thread has run, it still retrieves its original
value, demonstrating thread isolation.

You can also override the initialValue() method to provide a default value when a thread first accesses the ThreadLocal
variable:

```Java

private static final ThreadLocal<Integer> threadLocalCounter = new ThreadLocal<Integer>() {
    @Override
    protected Integer initialValue() {
        return 0; // Default value for each thread
    }
};
```

**Use Cases for ThreadLocal**

**ThreadLocal is particularly useful in scenarios where:**

**Maintaining Thread-Specific Context**: When each thread needs to maintain its own independent context or state, such
as user session information in a web application (e.g., username, session ID), database connection objects, or
transaction details. This avoids passing these values as parameters through numerous method calls.

**Handling Non-Thread-Safe Objects**: When working with objects that are not thread-safe (e.g., SimpleDateFormat,
Calendar), ThreadLocal can provide each thread with its own instance, eliminating the need for explicit synchronization
and potential performance bottlenecks.

**Implicit Argument Passing:** For "implicit arguments" or contextual information that needs to be available to various
methods within a thread's execution path without explicitly passing them as method parameters. This improves code
readability and reduces method signature clutter.

**Performance Optimization**: In cases where creating new instances of certain objects is expensive, ThreadLocal can
allow each thread to reuse its own instance, leading to performance improvements compared to creating a new instance for
every operation or using synchronization mechanisms.

# Blocking queue

A BlockingQueue in Java is an interface found within the java.util.concurrent package. It represents a queue that
supports operations that wait for the queue to become non-empty when retrieving an element, and wait for space to become
available in the queue when storing an element. This "blocking" behavior is crucial in multithreaded environments for
safely and efficiently exchanging data between producer and consumer threads.
Key Features:
Blocking Operations: Provides put() and take() methods that block if the queue is full (for put) or empty (for take),
ensuring threads wait until the queue is in a suitable state.
Thread Safety: All operations are inherently thread-safe, allowing multiple threads to access the queue concurrently
without manual synchronization.
Bounded/Unbounded: Implementations can be either bounded (fixed capacity) or unbounded (no maximum limit).
Fairness (Optional): Some implementations offer fairness policies, ensuring threads are granted access in the order they
requested it.
Common Implementations in Java:
Java provides several built-in implementations of the BlockingQueue interface:
ArrayBlockingQueue: A bounded, array-backed blocking queue that orders elements FIFO (First-In-First-Out).
LinkedBlockingQueue: An optionally-bounded, linked-node-backed blocking queue that also orders elements FIFO. It can be
unbounded if no capacity is specified.
PriorityBlockingQueue: An unbounded blocking queue that orders elements according to their natural ordering or a
provided Comparator.
DelayQueue: An unbounded blocking queue of Delayed elements, where an element can only be taken when its delay has
expired.
SynchronousQueue: A blocking queue with a capacity of zero. Each put operation must wait for a corresponding take
operation, and vice-versa.
How to Implement (using ArrayBlockingQueue as an example):
Java

import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class BlockingQueueExample {

    public static void main(String[] args) {
        // Create a bounded BlockingQueue with a capacity of 5
        BlockingQueue<Integer> queue = new ArrayBlockingQueue<>(5);

        // Producer Thread
        Thread producer = new Thread(() -> {
            try {
                for (int i = 0; i < 10; i++) {
                    queue.put(i); // Blocks if the queue is full
                    System.out.println("Produced: " + i);
                    Thread.sleep(100); // Simulate some work
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        // Consumer Thread
        Thread consumer = new Thread(() -> {
            try {
                for (int i = 0; i < 10; i++) {
                    int item = queue.take(); // Blocks if the queue is empty
                    System.out.println("Consumed: " + item);
                    Thread.sleep(200); // Simulate some work
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        });

        producer.start();
        consumer.start();
    }

}
In this example:
An ArrayBlockingQueue with a capacity of 5 is created.
A producer thread continuously adds elements using put(). If the queue is full, the put() operation will block until a
consumer takes an element.
A consumer thread continuously takes elements using take(). If the queue is empty, the take() operation will block until
a producer adds an element.
This demonstrates the core principle of a blocking queue, where threads automatically synchronize their operations based
on the queue's state, simplifying concurrent programming.

# Race condition

A race condition in Java threads occurs when multiple threads concurrently access and modify shared resources, and the
final outcome depends on the unpredictable order or timing of their executions. This leads to non-deterministic
behavior, where the program's result can vary with each run, making it challenging to debug and ensure correctness.

*How Race Conditions Arise:*

**Shared Resources**: Race conditions are only possible when threads interact with a shared resource, such as a
variable, object, or file, that can be modified by more than one thread.

**Concurrent Access and Modification**: Multiple threads attempt to read or write to this shared resource
simultaneously.

**Non-Atomic Operations**: The operations performed on the shared resource are not atomic, meaning they are composed of
multiple steps (e.g., reading a value, modifying it, and writing it back). If a thread switch occurs between these
steps, another thread can intervene and alter the shared resource, leading to an inconsistent state.

Example:

Consider a simple counter variable count initialized to 0. If two threads simultaneously attempt to increment count by
1, the expected result is 2. However, a race condition can lead to an incorrect result:
Thread A: reads count (value is 0).
Thread B: reads count (value is 0).
Thread A: increments its local copy of count to 1.
Thread B: increments its local copy of count to 1.
Thread A: writes its local copy (1) back to count.
Thread B: writes its local copy (1) back to count.
The final value of count is 1 instead of the expected 2, as one of the increments was lost due to the interleaving of
operations.

Preventing Race Conditions:
To prevent race conditions, mechanisms are used to ensure that only one thread can access and modify a critical section
of code (where shared resources are accessed) at any given time. Common techniques in Java include:
synchronized keyword: Used to create synchronized methods or blocks, providing intrinsic locks that ensure mutual
exclusion.
java.util.concurrent.locks package: Offers more flexible and advanced locking mechanisms like ReentrantLock.
Atomic classes: Classes like AtomicInteger, AtomicLong, and AtomicReference provide atomic operations on single
variables without explicit locking, leveraging hardware-level instructions for performance.
Thread-safe data structures: Using concurrent collections like ConcurrentHashMap or CopyOnWriteArrayList which are
designed for safe concurrent access.

# Deadlock

A deadlock in Java is a critical situation in multithreaded programming where two or more threads become permanently
blocked, each waiting for a resource that another thread in the cycle holds.

This leads to a standstill where none of the involved threads can proceed, effectively halting parts or the entirety of
the application.

*Here's a breakdown of the key elements:*

**Mutual Exclusion**: Resources involved in a deadlock, like object locks acquired using the synchronized keyword, are
typically non-shareable. Only one thread can hold such a resource at a time.

**Hold and Wait**: A thread holds at least one resource while simultaneously waiting to acquire another resource that is
currently held by a different thread.

**No Preemption**: Resources cannot be forcibly taken away from a thread. They must be voluntarily released by the
thread holding them.

**Circular Wait**: A closed chain of threads exists, where each thread in the chain holds a resource that the next
thread in the chain requires. This forms a dependency cycle that cannot be broken.

*Example Scenario:*

Consider two threads, Thread A and Thread B, and two resources, Resource X and Resource Y.

Thread A acquires a lock on Resource X.

Thread B acquires a lock on Resource Y.

Thread A then attempts to acquire a lock on Resource Y, but it is held by Thread B,
so Thread A waits.

Thread B then attempts to acquire a lock on Resource X, but it is held by Thread A, so Thread B waits.

In this scenario, both threads are blocked indefinitely, waiting for each other to release the resources they need,
resulting in a deadlock.

# Semaphores
