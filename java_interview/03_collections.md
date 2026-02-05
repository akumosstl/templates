# Collections
Framework java Collections.

# HashSet and TreeSet

a. How HashSet and TreeSet internally works and what is the complexity to do operations like get, put on these
collections?
b. Will TreeSet allows null objects storage? If yes/no then why?
c. How TreeSet able to maintain sorting of objects.

**HashSet quick overview**

- store unique elements
- allow null values
- backed by a HashMap
- not maintain insertion order
- not thread-safe

**HashSet internal Working**

Java's HashSet internally utilizes a HashMap to store its elements and ensure uniqueness.

When a HashSet is created, it instantiates an internal HashMap.

The elements added to the HashSet become the keys in this underlying HashMap.

For each key (element), a constant, dummy Object value (often a private static final Object named PRESENT) is associated
in the HashMap. This constant value is used simply to satisfy the HashMap's key-value pair requirement.

**How Uniqueness is Maintained:**

Adding Elements: When add(E e) is called on a HashSet, it internally calls the put(K key, V value) method of its backing
HashMap. The element e is passed as the key, and the PRESENT constant is passed as the value.

Duplicate Check: The HashMap's put method checks if the key (the element being added) already exists. This check relies
on the hashCode() and equals() methods of the element's class.
If the key is new, the put method inserts the key-value pair and returns null. The HashSet's add method then returns
true, indicating a successful addition.

If the key already exists, the put method returns the old value associated with that key (which would be PRESENT). The
HashSet's add method then returns false, preventing the addition of the duplicate element.

**Other Operations:**

remove(Object o): This method calls the remove(Object key) method of the internal HashMap, passing the element to be
removed as the key.
contains(Object o): This method calls the containsKey(Object key) method of the internal HashMap.
size(), isEmpty(), clear(): These methods directly delegate to their corresponding methods in the internal HashMap.

**Key Characteristics Inherited from HashMap:**

No guaranteed order: HashSet does not maintain the insertion order of elements.

Performance: Operations like add, remove, and contains typically have an average time complexity of O(1) due to hashing.

Null elements: HashSet can store at most one null element, as HashMap can have one null key.

Not thread-safe: HashSet is not synchronized; external synchronization is required for thread-safe operations.

***TreeSet***

**Internal Working:**

TreeSet internally uses a TreeMap to store its elements. It maintains elements in a sorted order, either based on their
natural ordering (if they implement Comparable) or a custom Comparator provided during construction.

When an element is added, TreeSet inserts it into the underlying TreeMap as a key, with a dummy value.

The TreeMap itself is implemented using a self-balancing binary search tree, specifically a Red-Black Tree. This
structure ensures that the tree remains balanced, preventing worst-case scenarios for operations.

No, a Java TreeSet does not allow null elements by default. Attempting to add a null value will result in a
NullPointerException at runtime, typically from Java version 7 onwards.

**Why null is not allowed in TreeSet**

**Sorting Mechanism**: TreeSet maintains its elements in a sorted order, either by their natural ordering (if the
elements implement the Comparable interface) or by a custom Comparator provided at the time of creation.

**Comparison Failure**: The sorting process requires comparing elements using the compareTo() or compare() methods
internally. A null value cannot be compared to any other object using these methods, as calling a method on a null
reference throws a NullPointerException.

**Internal Implementation**: TreeSet is internally backed by a TreeMap, which does not allow null keys for the same
reason.

**Complexity of Operations:**

**Add (Put)**: O(log n), where n is the number of elements in the set, due to the tree traversal and balancing
operations.

**Remove**: O(log n).

**Contains (Get)**: O(log n).

Other NavigableSet operations (e.g., floor, ceiling, higher, lower): O(log n).

# ArrayList and LinkedList

a.Scenarios where you want to use ArrayList and LinkedList with reasons.
b. How Collections.sort(list of objects) works internally, what will be the complexity to sort elements using above
approach and how?

The choice between using an ArrayList and a LinkedList in Java depends on the specific operations that will be performed
most frequently.

***Scenarios for using ArrayList:***

Frequent random access to elements by index:

ArrayList stores elements in a contiguous block of memory, allowing for direct access to any element using its index in
O(1) time. This is ideal for situations where you need to retrieve elements quickly based on their position.

Reason: Direct memory access by index is highly efficient.

***Minimal insertions or deletions in the middle of the list:***

While ArrayList can resize, inserting or deleting elements in the middle requires shifting all subsequent elements,
which can be an O(n) operation. If these operations are infrequent, the benefits of fast random access often outweigh
this cost.

Reason: Contiguous memory allocation makes shifting elements expensive.

***When memory usage for references is a concern:***

ArrayList stores only the elements themselves, while LinkedList stores both the elements and pointers to the next (and
previous) elements. For large lists of primitive types or small objects, ArrayList might be more memory-efficient.

Reason: No overhead for node pointers.

***Scenarios for using LinkedList:***

1- Frequent insertions or deletions at the beginning or end of the list:

LinkedList allows for efficient insertion and deletion at the head or tail in O(1) time by simply updating pointers.

Reason: Only pointer adjustments are needed, no element shifting.

2- Frequent insertions or deletions in the middle of the list, where the insertion/deletion point is known (e.g., found by an iterator):

If you already have an iterator pointing to the insertion or deletion location, LinkedList can perform these operations
in O(1) time. However, if you need to traverse to find the location, it becomes O(n).

Reason: Pointer manipulation is efficient when the target node is directly accessible.

3- When you need to implement a Queue or Deque:

LinkedList implements both the List and Deque interfaces, making it a suitable choice for implementing data structures
like queues (FIFO) or double-ended queues, where operations at both ends are common.

Reason: Optimized for adding/removing elements from both ends.

***In summary:***

Choose ArrayList for scenarios emphasizing fast random access and infrequent modifications in the middle.
Choose LinkedList for scenarios emphasizing frequent insertions and deletions, especially at the ends, or when
implementing queue-like structures.

# HashMap

a. Internal working of HashMap (Any differences in internal implementation w.r.t JDK 1.7 and JDK 1.8), LinkedHashMap,
ConcurrentHashMap & TreeMap. How LinkedHashMap able to maintain insertion order of elements.

HashMap uses an array of buckets, where each bucket can hold a linked list or, in JDK 1.8 and later, a balanced tree (
specifically a Red-Black Tree) for collision handling.

When a key-value pair is added, the key's hashCode() determines the bucket index. If multiple keys map to the same
bucket (collision), they are stored in the linked list or tree at that index.

![HashMap internally](../assets/img/diagram/collections/hashMap_works.png "hashMap works")

***Hashmap dirty read***

a. How does rehashing work in a Hashmap?

A "dirty read" in the context of a HashMap (or any data structure) refers to a situation where one thread reads data
that has been modified by another thread, but those modifications have not yet been "committed" or made permanent. This
means the data being read might be in an inconsistent or temporary state, and could potentially be rolled back to its
previous value if the modifying thread fails or aborts its operation.

Here's a breakdown:

Uncommitted Changes: A thread modifies an entry in the HashMap. Before this thread finishes its operation and "commits"
the change (e.g., by releasing locks or ensuring consistency), another thread attempts to read that same entry.
Inconsistent State: The reading thread sees the modified, uncommitted value. If the modifying thread then fails or
decides to undo its changes (a rollback), the data that the reading thread saw becomes invalid or "dirty" because it no
longer reflects the true, committed state of the HashMap.

Example Scenario:

Imagine two threads, Thread A and Thread B, operating on a HashMap:
Thread A: Modifies the value associated with a key "X" in the HashMap.
Thread B: Reads the value associated with key "X" before Thread A has completed its operation and committed the change.
Thread A (Rollback): Thread A encounters an error and rolls back its changes, restoring the original value for key "X".
In this scenario, Thread B performed a dirty read because it read a value that was later discarded.

Why it matters in HashMap:

While HashMap itself isn't inherently transactional like a database, the concept of dirty reads can arise in concurrent
scenarios where multiple threads are accessing and modifying a HashMap without proper synchronization or when using a "
read uncommitted" isolation level (if applicable in a larger system using the HashMap as a component).

Prevention:

To prevent dirty reads in concurrent HashMap access, proper synchronization mechanisms are crucial, such as:

Collections.synchronizedMap(): Creates a synchronized wrapper around a HashMap, ensuring thread-safe access to its
methods.

ConcurrentHashMap: A thread-safe implementation of HashMap designed for high concurrency.

External Locking: Manually using locks (e.g., ReentrantLock) to protect access to the HashMap or specific entries.

These mechanisms ensure that a thread reading data will only see committed changes, thus preventing dirty reads and
maintaining data integrity.

Rehashing in a Java HashMap is the process of resizing the internal array (the "buckets") and redistributing the
existing key-value pairs into the new, larger array. This process is triggered when the HashMap's load factor exceeds a
predefined threshold, typically 0.75 by default.

Here's how rehashing works:

Threshold Exceeded: When the number of entries in the HashMap reaches a certain point (capacity * load factor), the
HashMap determines that it needs to rehash. For instance, with a default capacity of 16 and a load factor of 0.75,
rehashing occurs when the 13th element is added (0.75 * 16 = 12, so when the 12th element is added, the next addition
triggers rehashing).
New Array Creation: A new, larger array is created. Typically, this new array has double the capacity of the old array.
Recalculating Hash Codes and Buckets: All the existing key-value pairs from the old HashMap are iterated through. For
each entry:
The hashCode() of its key is recalculated.
A new bucket index is determined for the entry within the new, larger array, based on its hash code and the new array's
size. The calculation often involves a bitwise AND operation with (newCapacity - 1).
Redistribution: Each entry is then placed into its newly calculated bucket in the new array. If multiple entries hash to
the same bucket (a collision), they are typically stored in a linked list or, in newer Java versions for large buckets,
a balanced tree (like a red-black tree) within that bucket.
Old Array Garbage Collection: The old, smaller array is no longer referenced and becomes eligible for garbage
collection.
Why Rehashing is Necessary:
Maintain Performance: Rehashing prevents the HashMap from becoming too "dense" with entries in individual buckets. A
high load factor leads to more collisions, which degrades performance as the HashMap has to traverse longer linked lists
or trees to find elements, moving away from the desired O(1) average time complexity for operations.
Reduce Collisions: By increasing the number of buckets, the probability of collisions decreases, leading to a more even
distribution of entries and faster access times.

**JDK 1.7 vs. 1.8 Differences**

Collision Handling: In JDK 1.7, collisions were always handled by a linked list within each bucket. In JDK 1.8, if a
bucket's linked list exceeds a certain threshold (default 8), it is converted into a balanced Red-Black Tree to improve
performance for high collision scenarios, reducing search time from O(n) to O(log n).

Hashing Algorithm: The hash() method in JDK 1.8 was slightly optimized compared to JDK 1.7 to improve hash value
distribution and reduce collisions.

**ConcurrentHashMap**

ConcurrentHashMap is a thread-safe implementation of Map. It achieves thread safety and high concurrency by:

**Segmented Locking (Pre-JDK 8)**: In earlier versions, it divided the map into segments, each with its own lock. This
allowed multiple threads to access different segments concurrently.

**Node-level Locking (JDK 8+)**: From JDK 8 onwards, ConcurrentHashMap utilizes a more fine-grained locking mechanism.
It uses synchronized blocks on individual nodes or table segments, along with volatile fields and CAS (Compare-And-Swap)
operations, to ensure thread safety without locking the entire map during most operations.

# TreeMap

TreeMap implements the NavigableMap interface and stores key-value pairs in a sorted order based on the natural ordering
of its keys or a provided Comparator. Internally, it uses a Red-Black Tree, a self-balancing binary search tree, to
maintain this sorted order.

This structure allows for efficient retrieval of elements based on their order, as well as operations like finding the
floor, ceiling, or a sub-map within a range.

# LinkedHashMap

LinkedHashMap extends HashMap and maintains the insertion order of elements (or access order, if configured). It
achieves this by:

**Doubly Linked List**: In addition to the hash table structure inherited from HashMap, LinkedHashMap maintains a doubly
linked list that connects all its entries in the order they were inserted (or accessed).

**Head and Tail Pointers**: It keeps track of the head and tail of this linked list, allowing for constant-time
additions and removals from the ends.

**Node Structure**: Each entry (node) in the LinkedHashMap contains not only the key, value, and hash-related fields but
also before and after pointers to its predecessor and successor in the linked list, respectively. When an entry is added
or accessed (in access-order mode), its position in this linked list is updated accordingly.

**Summary**

- preserve the order of elmeent insertion
- has access order the most recently accessed element is placed at the end of iteration order
- It may have one null key and multiples null values
- Does not allow duplicate keys
- it is non-synchronized

# Concurrent APIs

a. Understanding of Concurrent APIs like CopyOnWriteArrayList, ConcurrentHashMap etc.

Concurrent APIs in Java, found primarily within the java.util.concurrent package, provide thread-safe and efficient
alternatives to traditional collections when working in multi-threaded environments. They are designed to manage
concurrent access to shared data structures, mitigating issues like ConcurrentModificationException and ensuring data
consistency.

**1. CopyOnWriteArrayList**

Mechanism: CopyOnWriteArrayList achieves thread-safety by creating a fresh copy of the underlying array for every
mutative operation (add, set, remove). Read operations, however, operate on the existing, unchanged array.

Use Cases: Ideal for scenarios with a high read-to-write ratio, where reads are frequent and writes are infrequent.
Examples include event listener lists or configuration data that changes rarely.

Advantages:

Reads do not require synchronization, making them highly efficient.
Iterators operate on an immutable snapshot, preventing ConcurrentModificationException.
Disadvantages:
High memory usage for frequent writes, as a new array is created each time.
Write operations can be expensive due to the copying overhead.

2. ConcurrentHashMap:
   Mechanism: ConcurrentHashMap achieves thread-safety and high concurrency by dividing the map into segments (or "bins"
   in newer versions) and allowing multiple threads to access and modify different segments concurrently. It uses
   fine-grained locking, where only the affected segment is locked during a write operation, rather than the entire map.
   Use Cases: Suitable for high-concurrency scenarios where both reads and writes are frequent. It's a common choice for
   caches or shared data structures in multi-threaded applications.
   Advantages:
   Offers significantly better performance than Collections.synchronizedMap() or Hashtable in concurrent environments.
   Allows concurrent reads and writes to different parts of the map.
   Disadvantages:
   Does not support null keys or values.
   Iterators provide a weakly consistent view, meaning they may not reflect modifications made after the iterator was
   created.
   In summary:
   CopyOnWriteArrayList prioritizes read performance and provides immutable snapshots for iteration, making it suitable
   for read-heavy scenarios with infrequent writes.
   ConcurrentHashMap prioritizes high concurrency for both reads and writes through fine-grained locking, making it
   suitable for scenarios with frequent modifications.
   Choosing between these and other concurrent collections depends on the specific access patterns and performance
   requirements of your multi-threaded application.

# HashCode and equals

a. Contract between object’s class equals () & hashcode (). How these methods going to be used inside hashing technique.
If you are using any object (like Employee class object) as a custom key inside the HashMap, how you will override these
methods?
b. What type of classes should be used as keys for hashmap()?
c. Further questions around this like overriding hashCode() with constant or returning
always true/false from equals() method?

The contract between equals() and hashCode() in Java is crucial for the correct functioning of hash-based collections
like HashMap and HashSet. The core principles of this contract are:

If two objects are equal according to the equals(Object o) method, then their hashCode() methods must produce the same
integer result.

If two objects have the same hash code, they are not necessarily equal. However, if their hash codes differ, then the
objects must be unequal.

**How these methods are used in hashing techniques (e.g., HashMap)**

When an object is used as a key in a HashMap:

Insertion: When you put(key, value) into a HashMap, the hashCode() of the key object is first used to determine which "
bucket" or array index the key-value pair should be stored in. This provides a quick initial placement.

Retrieval/Collision Resolution: If multiple keys hash to the same bucket (a "collision"), HashMap then uses the equals()
method to compare the new key with existing keys within that bucket to find the exact match or determine if a new entry
needs to be added.

**Overriding equals() and hashCode() for a Custom Key (e.g., Employee class)**

When using a custom object like an Employee as a key in a HashMap, you must override both equals() and hashCode() to
define what constitutes "equality" for your Employee objects and to ensure the contract is maintained.

Here's how you might override them for an Employee class with id and name fields:

```Java

public class Employee {
    private String id;
    private String name;

    public Employee(String id, String name) {
        this.id = id;
        this.name = name;
    }

    // Getters for id and name

    @Override
    public boolean equals(Object o) {
        if (this == o) return true; // Same object reference
        if (o == null || getClass() != o.getClass()) return false; // Null or different class
        Employee employee = (Employee) o;
        return id.equals(employee.id); // Define equality based on 'id'
    }

    @Override
    public int hashCode() {
        return id.hashCode(); // Generate hash code based on 'id'
    }
}
```

**Explanation of Overriding**

**equals(Object o)**: In this example, two Employee objects are considered equal if their id fields are equal. The
implementation includes checks for reference equality, nullity, and class type before comparing the id field.

**hashCode()**: The hashCode() method returns the hash code of the id field. This ensures that if two Employee objects
have the same id (and are thus equal according to equals()), they will also produce the same hash code, fulfilling the
contract.

By correctly overriding both methods, HashMap can effectively store and retrieve Employee objects based on your defined
notion of equality.

In Java, any object can technically be used as a key in a HashMap, but to function correctly and efficiently, the class
used for the keys must adhere to a specific contract regarding the hashCode() and equals() methods [2].

Specifically, the best classes to use as keys are immutable classes that provide robust, consistent implementations of
these two methods.

**Essential Requirements for Hashmap Keys**

For a HashMap to work predictably, the following principles must be followed by the key class:

**Override hashCode() and equals()**

If two objects are considered "equal" by the equals() method, their hashCode() methods must return the same integer
value [2].
If you override one method, you must override the other to maintain the contract defined in the Object class [2].
This ensures that when you put an object in the map, you can retrieve it later using an equivalent (but potentially
different) instance of the key class.
Immutability (Highly Recommended):
The values used to calculate the hashCode() of an object should never change after the object is inserted into the
HashMap [2].
If you change a mutable key's properties after it's in the map, its hash code might change. When you later try to
retrieve the value using the original hash, the map won't be able to find the key's location, and the entry will
become "lost" within the internal data structure [2].
Examples of Suitable Classes
The most common and reliable types of classes used as HashMap keys are:
Class Type Suitability Reason
String Excellent String is immutable and provides solid implementations of hashCode() and equals() [1].
Wrapper Classes Excellent Classes like Integer, Double, Long, etc., are immutable and designed for this use case [1].
Custom Immutable Classes Excellent Custom classes you create that have all final fields and correctly implemented
hashCode() and equals().
Enum Excellent Enums are inherently immutable and extremely efficient as keys (often used in EnumMap for maximum
performance) [1].
Mutable Custom Classes Poor Prone to "lost" entries if modified while in the map.
In summary, use classes that do not change state after creation and guarantee that equal objects always produce the same
hash code.

Overriding hashCode() to return a constant or equals() to always return true/false can have significant consequences,
especially when using objects in hash-based collections like HashMap or HashSet.

1. Overriding hashCode() to return a constant

**Violation of the hashCode() contract**: The hashCode() contract states that if two objects are equal according to the
equals() method, then their hashCode() values must be the same. While returning a constant doesn't directly violate this
if equals() is also correctly implemented to reflect this, it can lead to performance issues.

**Performance degradation in hash-based collections**: If hashCode() consistently returns a constant (e.g., 1), all
objects will be mapped to the same bucket in hash-based collections. This effectively turns the collection into a linked
list, degrading the average time complexity of operations like get(), put(), and contains() from O(1) to O(n).

2. Overriding equals() to always return true

**Violation of the equals() contract**: The equals() contract has several requirements, including reflexivity (x.equals(
x) must be true), symmetry (x.equals(y) if and only if y.equals(x)), and transitivity. If equals() always returns true,
it violates these principles unless every object is truly equal to every other object, which is rarely the case for
distinct instances.

**Incorrect behavior in collections**: Collections will treat all objects as equal, leading to unexpected behavior. For
example, a Set might only store one element, believing all others are duplicates.

3. Overriding equals() to always return false

**Violation of the equals() contract**: This violates the reflexivity requirement, as x.equals(x) would return false,
which is incorrect.

**Incorrect behavior in collections**: Collections would never consider any two objects equal, even if they represent
the same logical entity. This would prevent the detection of duplicates in Sets or correct key-value mapping in Maps.

In summary:

Always ensure that equals() and hashCode() are overridden together and adhere to their respective contracts.

A well-implemented hashCode() should distribute hash codes as evenly as possible to ensure efficient performance in
hash-based collections.

A well-implemented equals() should define a meaningful equivalence relation between objects, respecting reflexivity,
symmetry, transitivity, consistency, and null handling.

# Fail fast and failsafe

a. Which collection implementation is failfast and which all are failsafe? (Concurrent
modification exception)

In Java, "fail-fast" iterators immediately throw a ConcurrentModificationException if the collection is modified
structurally while being iterated, ensuring data consistency in single-threaded or externally synchronized environments.

In contrast, "fail-safe" iterators do not throw an exception and operate on a snapshot or clone of the collection,
allowing modifications without failure but with potential performance overhead. They are used in concurrent collections,
such as CopyOnWriteArrayList, to provide a stable view even when the underlying collection is changing.

**Fail-fast**

Behavior: Throws ConcurrentModificationException if the collection is structurally modified (elements added, removed, or
updated) during iteration.

Mechanism: Iterates directly on the original collection and checks for modifications against an internal counter.

Pros:Immediately alerts the developer to invalid concurrent modifications. More efficient, as it doesn't create a copy
of the collection.

Cons: Not suitable for multi-threaded environments where concurrent modifications are expected.

Examples: Standard collections like ArrayList, HashMap, HashSet, and Vector.

1. Fail-Fast Example (using ArrayList)

This example shows an ArrayList (fail-fast) throwing an exception when an element is removed during iteration.

```java
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class FailFastExample {
    public static void main(String[] args) {
        List<String> colors = new ArrayList<>();
        colors.add("Red");
        colors.add("Green");
        colors.add("Blue");

        Iterator<String> iterator = colors.iterator();

        System.out.println("--- Starting Fail-Fast Iteration ---");
        while (iterator.hasNext()) {
            String color = iterator.next();
            System.out.println("Processing: " + color);

            // Attempting to modify the list while iterating (Fail-Fast behavior)
            if (color.equals("Green")) {
                colors.remove("Green"); // This causes ConcurrentModificationException
            }
        }
        // This line won't be reached due to the exception
        System.out.println("--- Iteration Finished ---");
    }
}
```

Output (will stop at "Processing: Green"):

```bash
--- Starting Fail-Fast Iteration ---
Processing: Red
Processing: Green
Exception in thread "main" java.util.ConcurrentModificationException
	at java.base/java.util.ArrayList$Itr.checkForComodification(ArrayList.java:970)
	at java.base/java.util.ArrayList$Itr.next(ArrayList.java:996)
	// ... (rest of stack trace)
```

**Fail-safe**

Behavior: Allows modifications to the underlying collection while iterating without throwing an exception.

Mechanism: Works on a clone or snapshot of the collection.

Pros: Stable iteration in multi-threaded scenarios without the need for external synchronization.

Cons: Less memory-efficient due to the overhead of creating a copy. Slightly slower performance because of the copying
overhead.

Examples: Concurrent collections like CopyOnWriteArrayList and the iterators for ConcurrentHashMap's key set.

In Java, the distinction between fail-fast and fail-safe applies to iterators used with collection implementations,
specifically in how they handle concurrent modifications.

**In Summary:**

Fail-fast iterators prioritize early detection of concurrent modification issues by throwing an exception.

Fail-safe iterators prioritize uninterrupted iteration, even in the face of concurrent modifications, by working on a
copy of the collection.

# Iterators

a. Which all iterators are available as part of collection API?
b. What add-on feature does list Iterator provides in comparison to other iterator?

*The primary iterators available as part of the Java Collections API are:*

**Iterator**: This is the most fundamental iterator. It provides a way to traverse elements in a collection in a
forward-only direction. It also allows for the safe removal of elements from the underlying collection during iteration
using the remove() method. All Collection implementations provide an iterator() method that returns an Iterator
instance.

```java
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class ListIteratorExample {

    public static void main(String[] args) {
        // Create an ArrayList of Strings
        List<String> fruits = new ArrayList<>();
        fruits.add("Apple");
        fruits.add("Banana");
        fruits.add("Orange");
        fruits.add("Mango");

        // Obtain an Iterator for the List
        Iterator<String> iterator = fruits.iterator();

        // Iterate through the list using the Iterator
        System.out.println("Fruits in the list:");
        while (iterator.hasNext()) {
            String fruit = iterator.next(); // Get the next element
            System.out.println(fruit);
        }

        // Demonstrate removing an element during iteration (optional)
        // Reset the iterator to iterate again
        iterator = fruits.iterator();
        System.out.println("\nRemoving 'Orange' during iteration:");
        while (iterator.hasNext()) {
            String fruit = iterator.next();
            if (fruit.equals("Orange")) {
                iterator.remove(); // Safely remove the current element
            }
        }

        // Print the list after removal
        System.out.println("Fruits after removing 'Orange':");
        for (String fruit : fruits) { // Using enhanced for loop for simplicity after modification
            System.out.println(fruit);
        }
    }
}

```

**ListIterator**: This iterator extends the Iterator interface and is specifically designed for List implementations. It
offers more functionality than a standard Iterator, including:

1. Bidirectional traversal (forward and backward) using next() and previous().
2. Adding elements to the list during iteration using add().
3. Modifying existing elements using set().
4. Retrieving the index of the next or previous element using nextIndex() and previousIndex().

**Spliterator**: Introduced in Java 8, Spliterator is a specialized iterator designed for parallel processing and
efficient splitting of collections for parallel computations. It offers methods like tryAdvance() for sequential
processing, trySplit() for dividing the collection into smaller parts, and forEachRemaining() for applying an action to
the remaining elements.

While Enumeration is an older interface that served a similar purpose to Iterator in earlier versions of Java for legacy
classes like Vector and Hashtable, it is not part of the modern Java Collections Framework and is generally superseded
by Iterator.

The ListIterator in Java provides several key features compared to the basic Iterator, primarily the ability to traverse
a list in both forward and backward directions and modify the list during iteration.

***What is the Iterator used in an enhanced for, know as "for-each" loop?***

The enhanced for loop in Java, also known as the "for-each" loop, internally uses an Iterator when iterating over
Collections that implement the Iterable interface. For arrays, it uses a traditional index-based for loop structure.

**For Collections (e.g., ArrayList, HashSet):**

When you use an enhanced for loop with a Collection, the Java compiler automatically translates it into code that uses
the iterator() method of the Iterable interface. This method returns an Iterator object, which is then used to traverse
the collection.
Consider this example:

```Java

List<String> names = new ArrayList<>();
names.

add("Alice");
names.

add("Bob");

for(
String name :names){
        System.out.

println(name);
}
```

This code is effectively translated by the compiler into something similar to this:

```Java

List<String> names = new ArrayList<>();
names.

add("Alice");
names.

add("Bob");

Iterator<String> iterator = names.iterator();
while(iterator.

hasNext()){
String name = iterator.next();
    System.out.

println(name);
}
```

For Arrays:

When you use an enhanced for loop with an array, the compiler translates it into a traditional for loop that uses an
index to access each element. No Iterator object is involved in this case.

For example:

```Java

int[] numbers = {1, 2, 3};

for(
int number :numbers){
        System.out.

println(number);
}
```

This is effectively translated to:

```Java

int[] numbers = {1, 2, 3};

for(
int i = 0;
i<numbers.length;i++){
int number = numbers[i];
    System.out.

println(number);
}
```

# IdentityHashMap and WeakHashMap

IdentityHashMap and WeakHashMap are both specialized Map implementations in Java, but they differ in how they handle
keys. IdentityHashMap uses reference equality (\(==\)) instead of equals() to compare keys, treating two distinct
objects with the same content as different keys. WeakHashMap uses weak references for its keys, allowing map entries to
be garbage collected when a key is no longer strongly referenced elsewhere. IdentityHashMap Key Comparison: Compares
keys using the == operator (reference equality) rather than the .equals() method.Key Uniqueness: Two keys are considered
the same only if they are the exact same object in memory, even if their content is identical.Use Cases: Useful in rare,
low-level scenarios where object identity is more important than content equality, such as in debugging tools or when
dealing with objects that have poorly implemented or intentionally perverse equals() methods.Performance: Can be faster
than a standard HashMap because it bypasses the .equals() and .hashCode() methods. WeakHashMap Key Comparison: Uses a
standard HashMap approach with .equals() and .hashCode() for comparison.Key Uniqueness: Uses weak references for keys.
This means that if a key is only referenced by the WeakHashMap (and no other part of the program has a strong reference
to it), the Java garbage collector is free to discard the key and its associated value.Use Cases: Useful for
memory-sensitive applications, like creating caches or mappings where entries should be automatically removed when the
key is no longer in use elsewhere.Behavior: The removal of entries happens automatically during garbage collection, and
it may appear that entries are being silently removed at any time.

# LinkedList

A LinkedList stores elements in a series of interconnected "nodes" rather than in contiguous memory locations like an
array. This structure allows for dynamic resizing and efficient insertion/deletion operations, particularly at the
beginning or middle of the list.

**Here's how it works internally:**

**Nodes**: The fundamental building block of a LinkedList is the "node." Each node typically contains:

**Data**: The actual element or value stored in the list.

**Next Pointer/Reference**: A pointer or reference to the subsequent node in the sequence. In a singly linked list, this
is the only pointer.

**Previous Pointer/Reference (in Doubly Linked Lists)**: In a doubly linked list, each node also contains a pointer or
reference to the preceding node.

**Head and Tail:**

**Head**: A reference variable, often called head, points to the first node in the list. If the list is empty, the head
typically points to null.

**Tail**: In many implementations, particularly doubly linked lists, a tail reference variable points to the last node
in the list.

**Linking Nodes:**

Nodes are connected by their "next" (and "previous" in doubly linked lists) pointers. Each node's "next" pointer holds
the memory address of the next node in the sequence.
The "next" pointer of the last node in the list typically points to null, signifying the end of the list.

**Insertion:**

To insert an element, a new node is created with the new data.
The pointers of the surrounding nodes are then updated to include the new node in the sequence. For example, if
inserting in the middle, the "next" pointer of the node before the insertion point is updated to point to the new node,
and the new node's "next" pointer is updated to point to the node that was originally next.

**Deletion:**

To delete an element, the pointers of the surrounding nodes are again updated to bypass the node to be removed. The "
next" pointer of the node preceding the deleted node is updated to point to the node that followed the deleted node. The
deleted node then becomes unreferenced and eligible for garbage collection.
This linked structure, where elements are not necessarily stored contiguously but are linked through references, is what
enables the dynamic nature and efficient modifications of a LinkedList.

# HashTable

In Java, a Hashtable stores data in key-value pairs and internally uses an array of "buckets" to achieve efficient
storage and retrieval. Here's a breakdown of its internal workings:

**Hashing the Key**: When you add a key-value pair using put(key, value), the Hashtable first calculates a hash code for
the key using its hashCode() method. This hash code is an integer representing the key.

**Determining the Bucket Index**: The calculated hash code is then used to determine the index in the internal array
where the key-value pair should be stored. This is typically done by taking the hash code modulo the number of buckets
in the Hashtable:

```Java

index =hashCode %numberOfBuckets;
```

**Collision Handling (Chaining)**: It's possible for different keys to produce the same hash code, or for different hash
codes to map to the same bucket index. This situation is called a "collision." Hashtable resolves collisions using
chaining. Each bucket in the internal array actually holds a linked list (or similar data structure) of entries. If a
collision occurs, the new key-value pair is added to the linked list at that specific bucket index.

**Storing the Entry**: Each element in these linked lists is an "entry" object, which typically stores both the key and
its associated value.

**Retrieval (get(key))**: When you want to retrieve a value using get(key), the Hashtable again calculates the hash code
of the provided key and determines the corresponding bucket index. It then traverses the linked list at that index,
comparing the provided key with the keys of each entry in the list using the equals() method. Once a matching key is
found, its associated value is returned.

**Resizing (Rehashing)**: To maintain efficiency, Hashtable automatically resizes and reorganizes its internal array
when a certain "load factor" (a measure of how full the table is) is exceeded. This process is called "rehashing" and
involves creating a larger array and re-inserting all existing key-value pairs into their new, calculated locations.

**Key Requirements for Keys:**

For Hashtable to function correctly, the objects used as keys must properly implement both the hashCode() and equals()
methods.

hashCode(): Should return a consistent hash code for equal objects.

equals(): Should correctly determine if two objects are equal.

Synchronization:
A crucial aspect of Hashtable is that it is synchronized, meaning its methods are thread-safe. This makes it suitable
for use in multi-threaded environments, but it can also introduce performance overhead compared to unsynchronized
alternatives like HashMap.

# LinkedHashMap vs LinkedHashSet

LinkedHashMap and LinkedHashSet are both part of Java's Collections Framework and maintain insertion order, but they
differ fundamentally in how they store data and their intended use:

1. Data Storage:

LinkedHashMap: Stores data as key-value pairs. Each entry in a LinkedHashMap consists of a unique key and its associated
value. It's designed for mapping keys to values, similar to a dictionary.

LinkedHashSet: Stores unique elements as a set. It's designed to hold a collection of distinct elements, where the order
of insertion is preserved. Internally, a LinkedHashSet uses a LinkedHashMap, where each element of the set is stored as
a key in the underlying map, and a constant dummy object is used as the value.

2. Purpose and Usage:

LinkedHashMap: Used when you need to associate data with specific identifiers (keys) and retrieve or update values based
on those keys, while also needing to iterate through the entries in the order they were inserted.

LinkedHashSet: Used when you need a collection of unique items where the order of insertion is important for iteration,
but you don't need to associate values with each item.

3. Duplicates:

LinkedHashMap: Allows duplicate values but not duplicate keys. If you insert a key-value pair with an existing key, the
old value associated with that key will be replaced.

LinkedHashSet: Does not allow duplicate elements. If you attempt to add an element that already exists in the set, the
operation will be ignored, and the set will remain unchanged.

**In summary**

LinkedHashMap: is for ordered key-value mappings.

LinkedHashSet: is for ordered collections of unique elements.

## What is the main differences among Collections reggard the iteration?

The primary difference among Java collections regarding element iteration lies in the capabilities of their respective
iterators and the underlying structure of the collection itself. While all Collection implementations can be iterated
using a basic Iterator, specific sub-interfaces like List offer enhanced iteration capabilities through ListIterator.

**Here's a breakdown**

**Basic Iteration (using Iterator)**

1. All Collection implementations (Lists, Sets, Queues) can be iterated using the Iterator interface.

2. Iterator provides methods for forward-only traversal: hasNext() to check for the next element, next() to retrieve it,
   and remove() to safely remove the last element returned by next().
   Iterator does not offer methods for adding elements or modifying existing elements during iteration, nor does it
   provide index-based access.

**Enhanced List Iteration (using ListIterator)**

Only List implementations (e.g., ArrayList, LinkedList) support ListIterator.
ListIterator extends Iterator and adds capabilities for bidirectional traversal:

hasPrevious() and previous() methods for backward iteration.

It also allows modification of the list during iteration: add(E e) to insert an element, and set(E e) to replace the
last element returned by next() or previous().
ListIterator provides index-based access: nextIndex() and previousIndex() to retrieve the index of the next or previous
element.

**Map Iteration**

Map is not a Collection and thus does not directly implement Iterable.
To iterate over a Map, one must obtain a Collection view of its elements:

keySet(): Returns a Set of the map's keys, allowing iteration over keys.

values(): Returns a Collection of the map's values, allowing iteration over values.
entrySet(): Returns a Set of Map.Entry objects, allowing iteration over key-value pairs.

Each of these views can then be iterated using a standard Iterator.
In essence, the main difference is the level of control and functionality offered by the iteration mechanism, ranging
from basic forward traversal with Iterator to advanced bidirectional traversal with modification and index access
provided by ListIterator for List types, and specialized view-based iteration for Maps.

## What is the complexity of iteration in the main java collection classes?

The time complexity of iteration in Java's main collection classes generally depends on the underlying data structure.
Here's a breakdown:

1. Lists (implementing List interface):

ArrayList: Iterating through an ArrayList is O(n), where 'n' is the number of elements. This is because ArrayList stores
elements in a contiguous array, allowing direct access to each element in constant time (O(1)). The iteration simply
visits each element sequentially.

LinkedList: Iterating through a LinkedList is also O(n). While accessing an element by index in a LinkedList is O(n),
iterating using an Iterator or enhanced for loop traverses the linked nodes sequentially, with each "next" operation
being O(1).

2. Sets (implementing Set interface):

HashSet: Iterating through a HashSet is O(n), where 'n' is the number of elements. The iteration involves traversing the
underlying hash table, which can have some overhead related to hash collisions but ultimately visits each element once.

LinkedHashSet: Iterating through a LinkedHashSet is O(n). It maintains a doubly-linked list running through its entries,
preserving insertion order, which allows for efficient sequential iteration.

TreeSet: Iterating through a TreeSet is O(n). It stores elements in a Red-Black tree, and iteration involves an in-order
traversal of the tree, visiting each node once.

3. Maps (implementing Map interface):

HashMap: Iterating through the key set, value collection, or entry set of a HashMap is O(n), where 'n' is the number of
entries. Similar to HashSet, it involves traversing the underlying hash table.

LinkedHashMap: Iterating through a LinkedHashMap is O(n). It maintains a doubly-linked list of its entries, preserving
insertion order, enabling efficient sequential iteration.

TreeMap: Iterating through a TreeMap is O(n). It stores entries in a Red-Black tree, and iteration involves an in-order
traversal of the tree.

**In summary**

For most standard Java collection classes, the time complexity of a full iteration (visiting every element once) is O(
n), as it requires processing each of the 'n' elements. The specific constant factors involved might differ based on the
underlying data structure, but the overall linear relationship with the number of elements holds true.

## What is the complexity of access elements in the main java collection classes?

The complexity of accessing elements in Java's main collection classes varies depending on the specific class and the
access method used.

**Here's a breakdown for common collections**

**ArrayList**

Access by index (e.g., get(index)): O(1) – Constant time, as it's backed by an array and elements can be directly
accessed using their index.

**LinkedList**

Access by index (e.g., get(index)): O(N) – Linear time, as it requires traversing the list from the beginning or end to
reach the desired index.

**HashSet**

Access (e.g., contains()): O(1) on average – Constant time on average, assuming a good hash function and proper
distribution of elements in the hash table. In the worst case (e.g., many hash collisions), it can degrade to O(N).

**TreeSet**

Access (e.g., contains()): O(log N) – Logarithmic time, as it's based on a balanced binary search tree, allowing
efficient searching.

**HashMap**

Access by key (e.g., get(key)): O(1) on average – Constant time on average, similar to HashSet, relying on efficient
hashing. Worst-case can be O(N).

**TreeMap**

Access by key (e.g., get(key)): O(log N) – Logarithmic time, as it's based on a balanced binary search tree, providing
efficient key-based retrieval.

Summary:

Fastest access by index: ArrayList (O(1))

Fastest access by value/key (average case): HashSet, HashMap (O(1))

Fastest access by value/key (guaranteed): TreeSet, TreeMap (O(log N))

Slowest access by index: LinkedList (O(N))

## Thread-safe classes collection

Thread-Safe Collections (e.g., Vector, Hashtable, Collections.synchronizedList(), ConcurrentHashMap).

## What is the different between TreeMap and TreeSet regard the order elements?

TreeSet stores unique elements in a single sorted order (natural or custom), acting like an ordered set, while TreeMap
stores unique keys mapped to values, sorting by those keys to create a sorted dictionary, allowing duplicate values but
not duplicate keys; both use red-black trees internally for efficient log(n) operations, but serve different
purposes—TreeSet for ordered unique items, TreeMap for sorted key-value mappings.

**TreeSet**

Stores: Unique elements (no duplicates).

Order: Elements are sorted based on their natural order or a provided Comparator.
Interface: Implements SortedSet and NavigableSet.

Use Case: Storing a collection of unique items in sorted order (e.g., sorted list of names).

**TreeMap**

Stores: Key-value pairs, with unique keys but allowing duplicate values.

Order: Keys are sorted, and the map maintains this sorted order.

Interface: Implements Map and NavigableMap.
Use Case: Creating a sorted dictionary or lookup table (e.g., mapping user IDs to names).

**Key Differences Summarized**

Data Structure: TreeSet holds single objects; TreeMap holds key-value pairs.

Sorting Basis: TreeSet sorts the elements themselves; TreeMap sorts by the keys.

Duplicates: TreeSet disallows duplicate elements; TreeMap disallows duplicate keys but allows duplicate values.

# LinkedList

The java.util.LinkedList class in Java is implemented as a doubly linked list. This means that each element within the
list, referred to as a "node," contains not only the actual data but also references (pointers) to both the preceding
and succeeding nodes in the sequence.

Here's a breakdown of its internal workings:

1. Node Structure

Each node in a LinkedList is an instance of a private static inner class, typically named Node<E>, where E represents
the type of data stored. This Node class contains three main components:

E item: This variable holds the actual data or element stored in that specific node.

Node<E> next: This is a reference to the next node in the sequence. If it's the last node, this reference will be null.

Node<E> prev: This is a reference to the previous node in the sequence. If it's the first node, this reference will be
null.

2. List Management

The LinkedList itself maintains two crucial references:

Node<E> first: A reference to the first node in the list.

Node<E> last: A reference to the last node in the list.

3. Operations (e.g., Adding an Element)

Adding to the end (add(E e)): When an element is added to the end of the list, a new Node is created with the provided
data. This new node's prev reference is set to the current last node, and its next reference is set to null. The next
reference of the previous last node is then updated to point to this new node, and the last reference of the LinkedList
is updated to point to the new node. If the list was empty, the first and last references both point to this new node.

Adding to the beginning (addFirst(E e)): A new Node is created. Its next reference points to the current first node, and
its prev reference is set to null. The prev reference of the previous first node is updated to point to this new node,
and the first reference of the LinkedList is updated to point to the new node.

4. Dynamic Sizing:

Unlike arrays, LinkedList does not store elements in contiguous memory locations. Instead, each node can be located
anywhere in memory, connected by references. This allows the LinkedList to grow or shrink dynamically as elements are
added or removed, without the need for resizing operations that can be costly in ArrayList.

5. Efficiency

The doubly linked nature of LinkedList makes insertions and deletions particularly efficient, especially at the
beginning or end of the list, as it only requires updating a few references (O(1) time complexity). However, accessing
an element by index (e.g., get(int index)) requires traversing the list from the beginning or end, resulting in O(n)
time complexity in the worst case.

# LinkedHashMap

LinkedHashMap in Java combines the features of a HashMap and a doubly linked list to provide ordered key-value storage.

**Internal Structure**

**Hash Table (like HashMap)**

1. LinkedHashMap uses a hash table, an array of buckets, to store its entries.

2. Each bucket can hold a linked list of entries (or a balanced tree in Java 8+ for larger buckets) to handle
   collisions. This allows for efficient put(), get(), and remove() operations with an average time complexity of O(1).

3. Doubly Linked List: In addition to the hash table structure, LinkedHashMap maintains a separate, global doubly linked
   list that connects all the entries in the map. Each Entry in the LinkedHashMap, which extends HashMap.Node, contains
   not only the key, value, hash, and next pointer (for the hash table bucket) but also before and after pointers. These
   before and after pointers link the entries together in the order they were inserted (or accessed, if configured).

**How it Works**

Insertion Order: When an entry is added to the LinkedHashMap, it is placed in the appropriate bucket of the hash table
based on its hash code. Simultaneously, the entry is also added to the end of the global doubly linked list using its
before and after pointers. This ensures that the iteration order of the map reflects the insertion order.

Access Order (Optional): LinkedHashMap offers a constructor LinkedHashMap(initialCapacity, loadFactor, accessOrder)
where accessOrder can be set to true. If accessOrder is true, whenever an entry is accessed (e.g., using get()), it is
moved to the end of the doubly linked list, effectively maintaining a "least recently used" (LRU) order.

Iteration: When iterating over a LinkedHashMap, the elements are traversed by following the after pointers of the global
doubly linked list, which provides the guaranteed order (insertion or access).

Removal: When an entry is removed, it is removed from both the hash table and the doubly linked list. The before and
after pointers of its neighboring entries in the linked list are updated to bypass the removed entry.

removeEldestEntry(): LinkedHashMap provides a protected method removeEldestEntry() that can be overridden to implement
custom eviction policies, such as an LRU cache, where the oldest entry is automatically removed when the map exceeds a
certain size. 