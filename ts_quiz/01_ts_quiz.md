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

They preserve type information while keeping flexibility.

```ts
interface Box<T> {
  value: T;
}

const stringBox: Box<string> = { value: "hello" };
const numberBox: Box<number> = { value: 42 };


interface HasLength {
  length: number;
}

// T must be a type that has a 'length' property
function logLength<T extends HasLength>(arg: T): T {
  console.log(arg.length);
  return arg;
}

logLength("hello"); // Works (string has a length property)
logLength([1, 2, 3]); // Works (array has a length property)
// logLength(123); // Error: Number does not have a length property


function identity<T>(arg: T): T {
  return arg;
}

// Explicitly setting the type parameter (optional due to inference)
let output1 = identity<string>("hello"); // Type of output1 is 'string'

// Using type argument inference (TypeScript automatically figures out the type)
let output2 = identity(42); // Type of output2 is 'number'
```


------------------------------------------------------------------------

# What is the difference between any and unknown?

-   any disables type checking completely.
-   unknown is type-safe and requires type narrowing before usage.

unknown is safer than any.

```ts
const foo = (anyType: any, unknownType: unknown) => {
  const str1: string = anyType; // => ok
  anyType(); // => ok
  anyType.foo; // => ok

  const str2: string = unknownType; // => erro
  unknownType(); // => erro
  unknownType.foo; // => erro
}
```

------------------------------------------------------------------------

# What is type inference?

TypeScript can automatically determine a variable's type based on its
value without explicit annotation.

Example: let count = 10; // inferred as number

------------------------------------------------------------------------

# What are Union and Intersection types?

-   Union (\|): A value can be one of multiple types.<br>
-   Intersection (&): Combines multiple types into one.<br>

Example: type A = { name: string }; type B = { age: number }; type C = A
& B;<br>

Union:<br>

```ts
function printStatusCode(code: string | number) {
  console.log(`My status code is ${code}.`);
}

printStatusCode(404); // Valid
printStatusCode('404'); // Valid
// printStatusCode(true); // Error: Argument of type 'boolean' is not assignable to parameter of type 'string | number'


```

Intersection:<br>

```ts
interface Name {
  firstName: string;
  lastName: string;
}

interface Age {
  age: number;
}

type Person = Name & Age;

const person1: Person = {
  firstName: 'Will',
  lastName: 'Smith',
  age: 42
};


```

------------------------------------------------------------------------

# What are Enums in TypeScript?

Enums allow defining a set of named constants.<br>

Example: enum Role { ADMIN, USER }<br>

------------------------------------------------------------------------

# What is a Decorator?

Decorators are special declarations that can modify classes, methods, properties, or parameters. They are widely used in frameworks like Angular.<br>

Example: @Component({...})

------------------------------------------------------------------------

# What is the difference between readonly and const?

-   const prevents variable reassignment.
-   readonly prevents property reassignment in objects or classes.

const applies to variables. readonly applies to properties.

Const<br>

```ts
const myArray = [1, 2];
myArray = [3, 4]; // ❌ Error: Cannot assign to 'myArray' because it is a constant.
myArray.push(3); // ⭕️ Works: Mutation of array content is allowed.
```

Readonly<br>

```ts
class Circle {
  readonly radius: number;
  constructor(radius: number) {
    this.radius = radius; // ⭕️ Works: Assignment in constructor is allowed.
  }
}
const circle = new Circle(12);
circle.radius = 15; // ❌ Error: Cannot assign to 'radius' because it is a read-only property.

```
# What are and how use ? and ?? operators?

In TypeScript, the single question mark is used in the ternary operator (? :) and the optional chaining (?.) operator, while the double question mark (??) is the nullish coalescing operator. <br>

***? Operator***<br>
The single question mark has two primary uses in TypeScript:<br>
Ternary Operator (Conditional Operator): This is a shorthand for an if-else statement and is a standard JavaScript feature.<br>
Syntax: condition ? expr1 : expr2<br>
Description: If the condition is true, it returns expr1; otherwise, it returns expr2.<br>
Example:<br>
```typescript
let age = 21;
let status = age >= 18 ? 'adult' : 'minor'; // status is 'adult'
```
Optional Properties/Parameters: Within type definitions (like interfaces or function parameters), a ? indicates that a property or parameter is optional.<br>
Example:<br>

```typescript
interface Person {
  name: string;
  age?: number; // 'age' is optional
}
function greet(x?: number) { /*...*/ } // 'x' is an optional parameter
```

***?. Operator (Optional Chaining)***<br>

The ?. operator allows you to safely access properties, methods, or elements in a chain where an intermediate reference might be null or undefined. <br>

Description: It works like the standard . chaining operator, but if any part of the chain is null or undefined, the expression "short-circuits" and returns undefined instead of throwing an error.<br>

Example:<br>
```typescript
let user = { profile: { name: 'Alice' } };
const userName = user?.profile?.name; // Alice
const userCity = user?.details?.address?.city; // undefined (doesn't throw an error)
``` 
***?? Operator (Nullish Coalescing)***
The ?? operator provides a default value for variables that are null or undefined. <br>

Description: It returns the right-hand operand only if the left-hand operand is null or undefined.<br>
Key Difference from ||: The logical OR (||) operator returns the right-hand side for any falsy value (like 0, "", or false), which can lead to unexpected behavior. ?? is more specific, treating falsy values that are not nullish (e.g., 0, false, "") as valid values.<br>
Example:<br>
```typescript
let userInput: string | undefined = undefined;
let defaultInput = userInput ?? 'Guest'; // defaultInput is 'Guest'

let count: number = 0;
let quantity = count ?? 1; // quantity is 0 (because 0 is not null or undefined)
let quantityOr = count || 1; // quantityOr is 1 (because 0 is falsy)
```

??= Operator (Nullish Coalescing Assignment) <br>
This is a related operator that assigns a value if the left operand is null or undefined. <br>

Example:<br>
```typescript
let user = { id: undefined, name: 'Bob' };
user.id ??= 1; // user.id becomes 1
```