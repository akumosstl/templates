# Object-Oriented Programming (OOP)
Java OOP principles.


# Aggregation and Composition

a. with two given classes A & B, how will you implement aggregation and composition programmatically?

**"Is-A" Relationship (Inheritance)**

This represents a relationship where one class is a specialized type of another class. It signifies that a subclass *"is
a"* type of its superclass. For example, a Car *"is a"* Vehicle, or a Dog *"is an"* Animal. This relationship is
implemented using the extends keyword in Java.

**"Has-A" Relationship (Composition/Aggregation)**

This represents a relationship where one class contains or *"has"* an instance of another class as a member. It
signifies that an object of one class is composed of or contains an object of another class. For example, a Car *"has
an"* Engine, or a Library *"has"* Books. This relationship is implemented by creating an instance of one class within
another as a field.

**Aggregation (Weak "has-a" relationship)**

In aggregation, class A *"has a"* B, but B can exist independently of A. This is typically implemented by passing an
instance of B to A's constructor or a setter method.

```java

// Class B can exist independently
class B {
    private String dataB;

    public B(String dataB) {
        this.dataB = dataB;
    }

    public void displayB() {
        System.out.println("Data from B: " + dataB);
    }
}

// Class A aggregates Class B
class A {
    private String dataA;
    private B bObject; // A has a reference to an existing B object

    // Constructor taking an existing B object
    public A(String dataA, B bObject) {
        this.dataA = dataA;
        this.bObject = bObject;
    }

    public void displayA() {
        System.out.println("Data from A: " + dataA);
        if (bObject != null) {
            bObject.displayB(); // Accessing B's functionality
        }
    }
}

public class AggregationExample {
    public static void main(String[] args) {
        B independentB = new B("Independent B data");
        A aggregatedA = new A("Aggregated A data", independentB);

        aggregatedA.displayA();

        // B can still exist and be used even if A is no longer referenced
        independentB.displayB();
    }
}

```

**Composition (Strong "part-of" relationship)**

In composition, class B is an integral *"part of"* class A, and B's lifecycle is dependent on A's. B objects are
typically created within A's constructor or methods, and their existence is tied to A's.

```java

// Class B is a part of Class A
class B {
    private String partDataB;

    public B(String partDataB) {
        this.partDataB = partDataB;
    }

    public void displayPartB() {
        System.out.println("Part data from B: " + partDataB);
    }
}

// Class A composes Class B
class A {
    private String dataA;
    private B bPart; // B is created and managed by A

    // Constructor creating a new B object
    public A(String dataA, String partDataB) {
        this.dataA = dataA;
        this.bPart = new B(partDataB); // B's creation is tied to A
    }

    public void displayA() {
        System.out.println("Data from A: " + dataA);
        if (bPart != null) {
            bPart.displayPartB(); // Accessing B's functionality
        }
    }
}

public class CompositionExample {
    public static void main(String[] args) {
        A composedA = new A("Composed A data", "B's internal part");

        composedA.displayA();

        // You cannot directly access the B object created within A as it's private
        // and its lifecycle is managed by A. If 'composedA' is garbage collected, 'bPart' will also be.
    }
}

```

# Immutable classes

a. Why String is immutable?
b. Unmodifiable vs Immutable collections.
c. How can you make immutable classes?
d. non-immutable objects under immutable class and if that non-immutable class further contains non-immutable objects
inside it. What will be your approach to make the classes immutable in such cases?
e. Examples from JDK APIs.

An immutable class in Java is a class whose instances cannot be modified after they are created. Once an object of an
immutable class is initialized, its internal state remains constant throughout its lifetime. Any operation that appears
to "change" an immutable object actually results in the creation of a new object with the modified state, leaving the
original object untouched.

***Key characteristics of immutable classes***

1 - No setter methods:

There are no public methods to change the object's fields after construction.

2 - All fields are final:

This ensures that the fields can only be initialized once, typically in the constructor.

3 - All fields are private:

This prevents direct access and modification of the internal state.

3 - The class itself is final:

This prevents subclassing, which could potentially introduce mutable behavior.

4 - Defensive copying of mutable components:***

If the class contains references to mutable objects (e.g., Date objects or collections), the constructor and getter
methods must perform deep copies to ensure that external modifications to these mutable objects do not affect the
immutable object's state.

5 -Initialize all fields in a parameterized constructor:

The constructor is the sole point for setting the initial values of the final fields.

***Examples from JDK APIs:***

Several core Java Development Kit (JDK) classes are designed as immutable, leveraging the benefits of immutability, such
as thread safety and predictable behavior.

***java.lang.String:***

The String class is the most prominent example of an immutable class in Java. When you perform operations like concat()
or replace() on a String, a new String object is created with the modified content, while the original String object
remains unchanged.

```java

String original = "Hello";
String modified = original.concat(" World");

    System.out.

println(original); // Output: Hello
    System.out.

println(modified); // Output: Hello World
```

***Primitive Wrapper Classes:***

All primitive wrapper classes, such as Integer, Long, Boolean, Character, Double, Float, Byte, and Short, are immutable.
Once an instance of these classes is created, its value cannot be changed.

```Java

Integer num1 = 10;
Integer num2 = num1 + 5; // Creates a new Integer object for num2

    System.out.

println(num1); // Output: 10
    System.out.

println(num2); // Output: 15
```

***Date and Time API (JSR 310):***

Classes introduced in Java 8's new Date and Time API, such as LocalDate, LocalTime, LocalDateTime, ZonedDateTime, and
Instant, are all immutable. Methods that appear to modify these objects (e.g., plusDays(), minusHours()) actually return
new instances.

```Java

LocalDate today = LocalDate.of(2025, 12, 3);
LocalDate tomorrow = today.plusDays(1);

    System.out.

println(today);    // Output: 2025-12-03
    System.out.

println(tomorrow); // Output: 2025-12-04
```

Examples of why immutable objects are good

1 -Security:

Strings are frequently used in security-sensitive operations, such as file paths, network connections, and database
queries. If strings were mutable, a malicious actor could potentially modify a string after it has been validated but
before it is used, leading to security vulnerabilities. Immutability ensures that the string's value remains constant
once created, preventing such attacks.

2 - Thread Safety:

Immutable objects are inherently thread-safe because their state cannot be modified by multiple threads concurrently.
This eliminates the need for explicit synchronization mechanisms when sharing String objects across threads, simplifying
concurrent programming and reducing the risk of data corruption.

3 - String Pool Optimization:

Java utilizes a "String Pool" (a special memory area in the heap) to store string literals. When a string literal is
created, the JVM first checks if an identical string already exists in the pool. If so, it returns a reference to the
existing string, avoiding the creation of a new object and saving memory. Immutability is crucial for this optimization,
as it guarantees that shared string objects will not be inadvertently modified by one reference, affecting others.

4 - Caching Hash Codes:

String objects are frequently used as keys in hash-based collections like HashMap. Since a string's content cannot
change, its hashCode() can be calculated once when the object is created and then cached. This cached hash code can be
reused in subsequent operations, providing a performance boost, as recalculating the hash code for mutable objects would
be necessary each time.

5 - Predictability and Reliability:

Immutability makes String objects more predictable and reliable. Developers can be confident that a String object's
value will not change unexpectedly, simplifying code reasoning and debugging.
When a String appears to be modified (e.g., using concat(), replace(), or the + operator), a new String object is
actually created with the modified content, and the original String object remains unchanged. The variable then points
to this new String object.

# Unmodifiable vs Immutable collections

In Java, the distinction between unmodifiable and truly immutable collections lies in how they handle changes to their
underlying data.

***Unmodifiable Collections:***

1 - Read-only Views

Unmodifiable collections, typically created using methods like Collections.unmodifiableList(),
Collections.unmodifiableSet(), or Collections.unmodifiableMap(), are essentially read-only views or wrappers around an
existing, potentially mutable, collection.

2 - No Direct Modification

You cannot directly add, remove, or clear elements using the reference to the unmodifiable collection; attempting to do
so will result in an UnsupportedOperationException.

3 - Reflect Underlying Changes

The crucial point is that if the original, underlying collection is modified by another reference, those changes will be
reflected in the unmodifiable view. This means the state of the unmodifiable collection can still change indirectly.

***Immutable Collections:***

1 - Truly Unchangeable:

Immutable collections, such as those provided by libraries like Guava (e.g., ImmutableList, ImmutableSet, ImmutableMap)
or the List.of(), Set.of(), and Map.of() methods introduced in Java 9, guarantee that their state will never change
after creation.

2 - Owns its Data

They achieve this by creating a copy of the elements from the source collection (if one is provided) and managing their
own internal data.

3 - No Reflection of Source Changes

If you create an immutable collection from a mutable one, subsequent changes to the original mutable collection will not
affect the immutable collection. It holds its own, independent set of data.

***In Summary***

**Unmodifiable**: Prevents direct modification through its own reference, but its state can change if the underlying
mutable collection is modified.

**Immutable**: Guarantees that its state cannot change at all after creation, regardless of external modifications to
any source collections. It holds its own copy of the data.

Example:

```java

import java.util.*;

public class CollectionComparison {
    public static void main(String[] args) {
        // Mutable List
        List<String> mutableList = new ArrayList<>();
        mutableList.add("Apple");
        mutableList.add("Banana");

        // Unmodifiable List (view of mutableList)
        List<String> unmodifiableList = Collections.unmodifiableList(mutableList);

        // Immutable List (copy of mutableList)
        List<String> immutableList = List.copyOf(mutableList); // Java 9+

        System.out.println("Initial mutableList: " + mutableList);
        System.out.println("Initial unmodifiableList: " + unmodifiableList);
        System.out.println("Initial immutableList: " + immutableList);

        // Modify the mutableList
        mutableList.add("Cherry");

        System.out.println("\nAfter modifying mutableList:");
        System.out.println("MutableList: " + mutableList);
        System.out.println("UnmodifiableList: " + unmodifiableList); // Reflects the change
        System.out.println("ImmutableList: " + immutableList); // Does NOT reflect the change
    }
}

```

# Override: instance or static variables

In Java, you cannot override instance or static variables (also known as fields).

***Instance Variables***

You can hide an instance variable in a subclass by declaring a field with the same name. This is called shadowing or
hiding, not overriding.

**The concrete reason**

Overriding is a concept that applies to methods and relies on dynamic dispatch (runtime polymorphism). When an
overridden method is called, the Java Virtual Machine (JVM) determines which implementation to execute based on the
actual runtime type of the object.

Variables, however, are resolved at compile time based on the declared (compile-time) type of the reference variable.

Example of Hiding (Shadowing):

```java
class Parent {
    String name = "ParentName";
}

class Child extends Parent {
    // This hides Parent.name, it does not override it.
    String name = "ChildName";
}

public class Test {
    public static void main(String[] args) {
        Parent p = new Child();
        // The output is "ParentName"
        // The variable accessed is determined by the reference type (Parent) at compile time.
        System.out.println(p.name);

        Child c = new Child();
        // The output is "ChildName"
        System.out.println(c.name);
    }
}

```

***Static Variables***

Static variables (class variables) are also resolved at compile time based on the reference type. Declaring a static
variable with the same name in a subclass also hides the superclass's static variable, it does not override it.

**The concrete reason**

Static members belong to the class itself, not an instance of the class. They exist independently of any specific
object. The mechanism of dynamic dispatch used for method overriding only works with instance methods that are part of
an object's state and behavior.

Example of Hiding:

```java
class ParentStatic {
    static String type = "ParentStatic";
}

class ChildStatic extends ParentStatic {
    // This hides ParentStatic.type, it does not override it.
    static String type = "ChildStatic";
}

public class TestStatic {
    public static void main(String[] args) {
        ParentStatic p = new ChildStatic();
        // The output is "ParentStatic"
        // Resolved at compile time based on the reference type (ParentStatic).
        System.out.println(p.type);

        // Accessing them directly via class names as intended for static variables
        System.out.println(ParentStatic.type); // ParentStatic
        System.out.println(ChildStatic.type); // ChildStatic
    }
}


```

# Overloading

a. Can you overload methods with different return types?
b. Can you overload with changing the argument types from primitive to wrapper type i.e
Void abc (int a) {}; Void abc (Integer a) {};
c. Be prepared with method overloading with Autoboxing and Widening

In Java, methods cannot be overloaded based solely on their return type. Method overloading relies on the method's
signature, which consists of the method name and the parameter list (number, type, and order of parameters).

The return type is not considered part of the method signature for overloading purposes.

If you attempt to define two methods with the same name and parameter list but different return types, the Java compiler
will report a compilation error. This is because the compiler would be unable to determine which method to invoke when a
call is made, as the return type alone does not provide sufficient information to distinguish between them.

For example, the following code would result in a compilation error:

```java
public class MyClass {
    public int calculate() {
        return 10;
    }

    // This will cause a compilation error
    public String calculate() {
        return "Hello";
    }
}

```

To successfully overload methods in Java, you must ensure that each overloaded method has a unique parameter list. This
can involve varying the number of parameters, the data types of the parameters, or the order of the parameters.

### Can you overload with changing the argument types from primitive to wrapper type i.e Void abc (int a) {}; Void abc (Integer a) {};

Yes, method overloading in Java is possible by defining methods with the same name but different parameter lists, and
this includes varying the argument types between primitive types and their corresponding wrapper classes.

# Autoboxing and Widening

Autoboxing and widening are both automatic type conversions in Java, but they operate on different types and for
different purposes.

***Autoboxing:***

**What it is**

The automatic conversion of a primitive data type to its corresponding wrapper class object.

**Purpose**

To allow primitive values to be used in contexts that require objects, such as Java Collections (e.g., ArrayList,
HashMap), which can only store objects.

Examples:

int to Integer
char to Character
boolean to Boolean

***Widening (Widening Primitive Conversion)***

**What it is**

The automatic conversion of a primitive data type to a larger-sized primitive data type. This conversion is always safe
as it does not involve any loss of data magnitude.

**Purpose**

To enable operations between different-sized primitive types and to assign a smaller primitive type to a variable of a
larger primitive type.

Examples:

byte to short
short to int
int to long
float to double
