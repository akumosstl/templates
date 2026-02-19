# TypeScript Interview Questions and Answers

# What is TypeScript?

TypeScript is a strongly typed superset of JavaScript developed by
Microsoft. It adds static typing, interfaces, and advanced tooling while
compiling to plain JavaScript.

------------------------------------------------------------------------

# What are the main benefits of TypeScript?

-   Static type checking
-   Better IDE support (autocompletion, refactoring)
-   Early error detection
-   Improved maintainability in large-scale applications

------------------------------------------------------------------------

# What is the difference between interface and type?

-   interface is primarily used to define object shapes and can be
    extended or merged.
-   type can define primitives, unions, intersections, tuples, and more
    complex types.

Interfaces are generally preferred for object contracts.

------------------------------------------------------------------------

# What are Generics?

Generics allow writing reusable and type-safe components.

Example: function identity`<T>`{=html}(value: T): T { return value; }

They preserve type information while keeping flexibility.

------------------------------------------------------------------------

# What is the difference between any and unknown?

-   any disables type checking completely.
-   unknown is type-safe and requires type narrowing before usage.

unknown is safer than any.

------------------------------------------------------------------------

# What is type inference?

TypeScript can automatically determine a variable's type based on its
value without explicit annotation.

Example: let count = 10; // inferred as number

------------------------------------------------------------------------

# What are Union and Intersection types?

-   Union (\|): A value can be one of multiple types.
-   Intersection (&): Combines multiple types into one.

Example: type A = { name: string }; type B = { age: number }; type C = A
& B;

------------------------------------------------------------------------

# What are Enums in TypeScript?

Enums allow defining a set of named constants.

Example: enum Role { ADMIN, USER }

------------------------------------------------------------------------

# What is a Decorator?

Decorators are special declarations that can modify classes, methods,
properties, or parameters. They are widely used in frameworks like
Angular.

Example: @Component({...})

------------------------------------------------------------------------

# What is the difference between readonly and const?

-   const prevents variable reassignment.
-   readonly prevents property reassignment in objects or classes.

const applies to variables. readonly applies to properties.
