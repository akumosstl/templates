# JavaScript Interview Questions and Answers

# What is JavaScript?

JavaScript is a high-level, interpreted programming language primarily
used to build interactive web applications. It supports event-driven,
functional, and object-oriented programming styles.

------------------------------------------------------------------------

# What is the difference between var, let, and const?

-   var: Function-scoped, can be redeclared and updated.
-   let: Block-scoped, can be updated but not redeclared in the same
    scope.
-   const: Block-scoped, cannot be updated or redeclared.

------------------------------------------------------------------------

# What is hoisting?

Hoisting is JavaScript's behavior of moving variable and function
declarations to the top of their scope during compilation. - var is
hoisted and initialized with undefined. - let and const are hoisted but
not initialized (Temporal Dead Zone).

------------------------------------------------------------------------

# What is closure?

A closure is a function that remembers its lexical scope even when
executed outside that scope.

Example: function outer() { let count = 0; return function inner() {
return ++count; } }

------------------------------------------------------------------------

# What is the difference between == and ===?

-   == compares values with type coercion.
-   === compares values and types (strict equality).

------------------------------------------------------------------------

# What is the event loop?

The event loop is a mechanism that handles asynchronous operations in
JavaScript by managing the call stack, callback queue, and microtask
queue.

------------------------------------------------------------------------

# What is the difference between synchronous and asynchronous code?

-   Synchronous code executes line by line.
-   Asynchronous code executes non-blocking operations using callbacks,
    Promises, or async/await.

------------------------------------------------------------------------

# What is a Promise?

A Promise represents a future value that may be fulfilled or rejected.
States: - Pending - Fulfilled - Rejected

------------------------------------------------------------------------

# What is async/await?

async/await is syntactic sugar over Promises that allows writing
asynchronous code in a more readable, synchronous-like style.

------------------------------------------------------------------------

# What is the difference between shallow copy and deep copy?

-   Shallow copy copies references of nested objects.
-   Deep copy duplicates all nested objects, creating fully independent
    copies.
