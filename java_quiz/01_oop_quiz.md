# Java Quiz

# What are the four pillars of OOP?

**Encapsulation, Abstraction, Inheritance, and Polymorphism.** These
principles help organize code into modular, reusable, and maintainable
components.

------------------------------------------------------------------------

# What is Encapsulation?

Encapsulation is the practice of hiding internal implementation details
and exposing only necessary functionality via public methods. It is
typically achieved using private fields and public getters/setters.

------------------------------------------------------------------------

# What is Abstraction?

Abstraction means hiding complex implementation details and exposing
only the essential behavior. In Java, it is achieved using abstract
classes and interfaces.

------------------------------------------------------------------------

# What is the difference between Abstract Class and Interface?

-   Abstract class can have both abstract and concrete methods.
-   Interface (Java 8+) can have default and static methods.
-   A class can implement multiple interfaces but extend only one
    abstract class.

------------------------------------------------------------------------

# What is Polymorphism?

Polymorphism allows objects to take multiple forms. - Compile-time
(method overloading) - Runtime (method overriding)

------------------------------------------------------------------------

# What is Method Overriding?

Method overriding occurs when a subclass provides a specific
implementation of a method already defined in its superclass. It enables
runtime polymorphism.

------------------------------------------------------------------------

# What is Method Overloading?

Method overloading allows multiple methods with the same name but
different parameter lists in the same class.

------------------------------------------------------------------------

# What is the difference between == and equals()?

-   `==` compares object references (memory address).
-   `equals()` compares object content (if overridden properly).

------------------------------------------------------------------------

# What is the difference between Composition and Inheritance?

-   Inheritance represents an "is-a" relationship.
-   Composition represents a "has-a" relationship and is generally
    preferred for flexibility and loose coupling.

------------------------------------------------------------------------

# What is the difference between final, finally, and finalize?

-   `final` → keyword to restrict inheritance, method overriding, or
    variable reassignment.
-   `finally` → block used in exception handling.
-   `finalize()` → method called by GC before object destruction
    (deprecated in modern Java).

------------------------------------------------------------------------


# Can You Overload Methods with Different Return Types?


❌ No — you **cannot overload methods based only on return type**.<br>

---

***Why?***<br>

Method overloading in Java is determined by the **method signature**, which includes:<br>

- Method name<br>
- Parameter list (type, number, order)<br>

The **return type is NOT part of the method signature**.<br>

---

***❌ Invalid Example (Compilation Error)***<br>

```java
public class MyClass {
    public int calculate() {
        return 10;
    }

    public double calculate() {   // Compilation error
        return 10.0;
    }
}
```
Even though the return types differ, the parameter list is the same — so this is not allowed.

***Valid Overloading***<br>

Overloading works when parameters differ:<br>

```java
public int calculate(int a, int b) {
    return a + b;
}

public double calculate(double a, double b) {
    return a + b;
}
```

Here the parameter types are different → valid overloading.<br>

Edge Case (Method Resolution Example)<br>

This is valid:<br>
```java
public int calculate(int a) {
    return a;
}

public double calculate(double a) {
    return a;
}
```

Because the parameter types differ.<br>

------------------------------------------------------------------------

# Can You Overload by Changing Primitive to Wrapper Type?


✅ Yes, you *can* overload methods by changing parameter types from primitive to wrapper types.<br>

Because:<br>

- `int` and `Integer` are different types.<br>
- Method overloading is based on the parameter list.<br>
- Autoboxing does not prevent compilation.<br>

---

***Example (Valid Overloading)***

```java
public void abc(int a) {
    System.out.println("primitive int");
}

public void abc(Integer a) {
    System.out.println("wrapper Integer");
}
```

***Important: Method Resolution & Autoboxing***<br>

Although it compiles, behavior depends on what is passed.<br>

Case 1: Passing primitive<br>
abc(10);<br>


Output:<br>

primitive int<br>


Primitive match is preferred over autoboxing.<br>

Case 2: Passing wrapper<br>
Integer value = 10;<br>
abc(value);<br>


Output:<br>

wrapper Integer<br>


Exact type match is chosen.<br>

Case 3: Passing null<br>
abc(null);<br>


Output:<br>

wrapper Integer<br>


Because null cannot be assigned to int.<br>

⚠ Potential Ambiguity<br>

If multiple wrapper types exist:<br>
```java
void abc(Integer a) {}
void abc(Long a) {}
```

Calling:<br>

```java
abc(null);
```

❌ Compilation error (ambiguous method call)<br>
