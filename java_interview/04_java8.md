# JDK 1.8
Java 8 (lambda, functional programming, date api, method repference, etc).


# Stream

a. What is a stream? How does it differ from a collection?

A collection is a data structure that stores elements, allowing them to be iterated over multiple times, while a stream
is a sequence of elements from a source that supports a one-time, lazy processing pipeline. Collections focus on storing
and managing data, whereas streams focus on processing data without storing it, using functional programming techniques.

# Operation

a. What is the difference between intermediate, terminal & short-circuit operations?

**Intermediate** operations transform a stream and are lazy, returning a new stream to be chained.

**Terminal** operations finalize the stream pipeline, trigger execution, and produce a result, which can be a non-stream
value or a side-effect.

**Short-circuit** operations are a characteristic of some operations (both intermediate and terminal) that can stop
processing early once a condition is met, improving performance.

![Stream operation](../../../../../resources/assets/img/diagram/java8/streamOperations.png "Stream operation")

**Intermediate operations**

**Purpose**: To transform or filter a stream.

**Execution**: They are lazy; they don't produce a result until a terminal operation is called.

**Result**: They return a new stream, allowing for a series of operations to be chained together.

Examples: filter(), map(), sorted(), distinct().

**Terminal operations**

**Purpose**: To produce a result from the stream or trigger a side-effect.

**Execution**: They are eager; they trigger the execution of the entire stream pipeline.

**Result**: They return a non-stream result, such as a primitive value, a collection, or nothing at all.

Examples: forEach(), count(), toArray().

**Short-circuit operations**

**Characteristic**: A property of certain operations (both intermediate and terminal) that allows the stream pipeline to
terminate early once a specific condition is satisfied.

**Purpose**: To improve performance by avoiding unnecessary computation.

Examples:
Intermediate: limit() (stops after a certain number of elements).
Terminal: findFirst() (stops as soon as the first element is found), anyMatch() (stops as soon as a match is found).

# Map and FlatMap

The core difference between map and flatMap stream operations lies in their handling of the transformation and the
resulting stream structure.

1. Transformation Type:

**map** (One-to-one): Transforms each element of the input stream into a single element of the output stream. It
maintains a one-to-one correspondence between input and output elements.

```Java
    List<String> words = Arrays.asList("hello", "world");
List<Integer> lengths = words.stream()
        .map(String::length) // "hello" -> 5, "world" -> 5
        .collect(Collectors.toList());
// lengths will be [5, 5]
```

**flatMap** (One-to-many and Flattening): Transforms each element of the input stream into a stream of zero or more
elements, and then flattens these individual streams into a single, combined output stream. This results in a
one-to-many mapping followed by a flattening operation.

```Java
    List<List<String>> listOfLists = Arrays.asList(
        Arrays.asList("apple", "banana"),
        Arrays.asList("orange", "grape")
);
List<String> fruits = listOfLists.stream()
        .flatMap(Collection::stream) // Flattens the streams of lists
        .collect(Collectors.toList());
// fruits will be ["apple", "banana", "orange", "grape"]
```

2. Output Stream Structure:
   map: If you apply map to a Stream<T> and the mapping function returns a Stream<R>, the result will be a Stream<
   Stream<R>>. It does not automatically flatten nested streams.

flatMap: When the mapping function returns a Stream<R>, flatMap automatically flattens these individual Stream<R>
instances into a single Stream<R>, effectively removing the nested structure.

In summary:
Use map when you want to transform each element into a single, corresponding element.
Use flatMap when you want to transform each element into multiple elements (represented as a stream) and then combine
all these resulting elements into a single, flattened stream.

# Pipelining

a. What is stream pipelining in Java 8?

Stream pipelining in Java 8 refers to the chaining of multiple operations on a stream of data to perform a sequence of
transformations and computations. This process is analogous to an assembly line, where data elements flow through a
series of stages, each performing a specific task, until a final result is produced.

A stream pipeline in Java 8 consists of three main components:

**Source**: This is the origin of the data, which can be a collection (like a List or Set), an array, an I/O channel, or
even a generator function. The source provides the initial elements for the stream.

**Intermediate Operations**: These are operations that transform the stream into another stream. Examples include
filter(), map(), sorted(), and limit(). Intermediate operations are lazy, meaning they are not executed immediately when
called. Instead, they are composed into a pipeline and only executed when a terminal operation is invoked. Each
intermediate operation returns a new Stream, allowing for method chaining and building up the pipeline.

**Terminal Operation**: This is the final operation in the pipeline that produces a result or a side effect. Examples
include collect(), forEach(), reduce(), and count(). The terminal operation triggers the execution of the entire
pipeline, processing the data through all the intermediate operations and producing the final outcome.

**Key characteristics of stream pipelining**

**Lazy Evaluation**: Intermediate operations are not executed until a terminal operation is invoked, optimizing
performance by only processing data when necessary.

**Internal Iteration**: Streams handle the iteration over elements internally, abstracting away the explicit loops often
found in traditional collection processing.

**Immutability**: Stream operations do not modify the original data source; instead, they produce new streams or
results.

**Functional Composition**: Operations are chained together in a fluent and declarative style, enhancing code
readability and conciseness.

**Parallel Processing**: Streams can easily be converted to parallel streams, allowing for efficient processing of large
datasets on multi-core processors.

Example:

```Java

List<String> names = Arrays.asList("Alice", "Bob", "Charlie", "David");

List<String> filteredAndMappedNames = names.stream() // Source
        .filter(name -> name.startsWith("A")) // Intermediate operation (filter)
        .map(String::toUpperCase) // Intermediate operation (map)
        .collect(Collectors.toList()); // Terminal operation (collect)

System.out.

println(filteredAndMappedNames); // Output: [ALICE]
```

# Functional interface

A functional interface in Java is an interface that contains only one abstract method. This single abstract method is
often referred to as the "functional method" or "SAM" (Single Abstract Method). Functional interfaces are a core feature
introduced in Java 8 to facilitate functional programming, working seamlessly with lambda expressions and method
references. They serve as a blueprint for these constructs, enabling cleaner and more concise code.

Rules for defining a functional interface:

Single Abstract Method (SAM): A functional interface must contain exactly one abstract method. This is the defining
characteristic that allows it to be implemented by a lambda expression, which provides the implementation for this
single method.

Default and Static Methods: Functional interfaces can include any number of default and static methods. These methods
have implementations within the interface itself and do not count towards the "single abstract method" rule, thus not
affecting the functional nature of the interface.

@FunctionalInterface Annotation (Optional but Recommended): The @FunctionalInterface annotation can be used to
explicitly declare an interface as a functional interface. While optional for compilation, it is highly recommended as
it ensures the interface adheres to the SAM rule. If you attempt to add more than one abstract method to an interface
annotated with @FunctionalInterface, the compiler will flag it as an error, preventing accidental violations of the
functional interface contract.

Example:

```Java

@FunctionalInterface
interface MyFunctionalInterface {
    void doSomething(); // The single abstract method

    default void doSomethingElse() {
        System.out.println("Doing something else...");
    }

    static void doStaticStuff() {
        System.out.println("Doing static stuff...");
    }
}
```

***Function, Consumer, Supplier , Predicate, BiFunction, BinaryOperator and UnaryOperator***

![Default core functions](../assets/img/diagram/java8/trullyCoreFunctionalInterfaces.png "Default core functionsoperation")

The java.util.function package in Java 8 introduced several predefined functional interfaces to support functional
programming with lambda expressions. Here are the definitions of the requested interfaces:

Function<T, R>: Represents a function that accepts one argument of type T and produces a result of type R. Its single
abstract method is R apply(T t).

Consumer<T>: Represents an operation that accepts a single input argument of type T and returns no result (void). Its
single abstract method is void accept(T t).

Supplier<T>: Represents a supplier of results of type T. It does not take any arguments but provides a result. Its
single abstract method is T get().

Predicate<T>: Represents a boolean-valued function that accepts one argument of type T. It is typically used for testing
conditions. Its single abstract method is boolean test(T t).

BiFunction<T, U, R>: Represents a function that accepts two arguments of types T and U and produces a result of type R.
Its single abstract method is R apply(T t, U u).

BinaryOperator<T>: Represents an operation upon two operands of the same type T, producing a result of the same type T
as the operands. It is a specialized BiFunction where all arguments and the result are of the same type. Its single
abstract method is T apply(T t1, T t2).

UnaryOperator<T>: Represents an operation on a single operand of type T that produces a result of the same type T as its
operand. It is a specialized Function where the input and output types are identical. Its single abstract method is T
apply(T t).

# Lambda expression

A lambda expression is a concise way to represent an anonymous function, meaning a function without a name. It allows
you to treat functionality as data, passing it as an argument to methods or assigning it to variables. Introduced in
many modern programming languages, including Java 8 and Python, lambda expressions provide a more compact syntax for
implementing functional interfaces or creating small, on-the-fly functions.

Advantages of Lambda Expressions:

Conciseness and Readability: Lambda expressions reduce boilerplate code, making your programs shorter and easier to
understand, especially for simple, single-expression functions.

Functional Programming Style: They enable a more functional programming approach, allowing you to pass code as arguments
and manipulate functions as first-class citizens.

Reduced Code Bloat: You can define behavior inline without needing to create separate classes or anonymous inner classes
for implementing functional interfaces.
Improved Iteration and Data Processing: Lambdas enhance the syntax for working with collections, making operations like
filtering, mapping, and reducing data more streamlined.

Where Lambda Expressions are Used:

Lambda expressions are widely used in various scenarios, including:
Implementing Functional Interfaces: In languages like Java, they are primarily used to provide implementations for
functional interfaces (interfaces with a single abstract method).
Collection Operations: They are commonly employed with collection APIs for tasks such as filtering elements,
transforming data, or performing aggregations.

```Java

List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
    names.

stream().

filter(name ->name.

startsWith("A")).

forEach(System.out::println);
```

Event Handling: In GUI applications, lambdas can simplify event listener implementations.

```Java

button.setOnAction(event ->System.out.

println("Button clicked!"));
```

Concurrency and Parallel Processing: They facilitate the use of functional constructs in concurrent programming,
enabling more efficient parallel processing of data.
Small, Disposable Functions: When you need a short, one-time function for a specific task, a lambda expression offers a
convenient and efficient way to define it.


***What is a method reference with different types?***

In Java, method references provide a concise syntax to refer to methods without executing them, acting as a shorthand
for certain lambda expressions. The "different types" of method references refer to the various ways you can specify the
target method, each with a distinct syntax and purpose. These types are: Reference to a Static Method.

This refers to a static method of a class.

```Java

ClassName::staticMethodName
```

Example: Math::max (refers to the static max method of the Math class).

Reference to an Instance Method of a Particular Object (Bound Reference):

This refers to an instance method of a specific, already-existing object.

```Java

objectReference::instanceMethodName
```

Example: myObject::doSomething (refers to the doSomething method of the myObject instance).

Reference to an Instance Method of an Arbitrary Object of a Particular Type (Unbound Reference):

This refers to an instance method where the target object is provided as the first argument to the functional interface
method.

```Java

ClassName::instanceMethodName
```

Example: String::compareToIgnoreCase (refers to the compareToIgnoreCase method of String objects, where the first String
in the comparison is the target object).

Reference to a Constructor.

This refers to a constructor of a class, effectively creating a new instance.

```Java

ClassName::new
```

Example: ArrayList::new (refers to the constructor of the ArrayList class, creating a new ArrayList instance).

These different types of method references allow for flexible and readable code when working with functional interfaces,
especially in conjunction with Java Streams.

***With interfaces having default methods, how JDK 1.8 able to sort out diamond problem?***

Java 8's introduction of default methods in interfaces does not completely eliminate the "diamond problem" in the same
way that single inheritance for classes does.

Instead, it provides clear rules for resolving potential ambiguities when a class implements multiple interfaces that
contain default methods with the same signature.

The key to how Java 8 handles this is through explicit conflict resolution by the implementing class:

Compiler Error for Ambiguity: If a class implements two or more interfaces that define default methods with the same
signature, and the class does not provide its own implementation of that method, the compiler will report an error. This
prevents the ambiguity of which default method to inherit.

Required Override: To resolve this ambiguity, the implementing class must override the conflicting default method. In
this override, the class can then explicitly choose which default method implementation to use from its parent
interfaces, or provide an entirely new implementation.

```Java

interface InterfaceA {
    default void commonMethod() {
        System.out.println("From InterfaceA");
    }
}

interface InterfaceB {
    default void commonMethod() {
        System.out.println("From InterfaceB");
    }
}

class MyClass implements InterfaceA, InterfaceB {
    @Override
    public void commonMethod() {
        // Option 1: Call a specific default method
        InterfaceA.super.commonMethod();
        // Option 2: Provide a new implementation
        // System.out.println("From MyClass");
    }
}
```

In essence, Java 8 does not automatically resolve the diamond problem for default methods; it mandates that the
developer explicitly resolve the conflict in the implementing class, thereby maintaining control and clarity over the
intended behavior.
