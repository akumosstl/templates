# Design Pattern:

## Explain the Creational, Structural and Behavioural design patterns?

Design patterns in Java are categorized into three main types: Creational, Structural, and Behavioral. Each category
addresses a different aspect of object-oriented design.

**1. Creational Design Patterns**

These patterns deal with object creation mechanisms, aiming to create objects in a manner suitable for the situation
while making the system independent of how its objects are created, composed, and represented.

**Types**: Singleton, Factory Method, Abstract Factory, Builder, Prototype.

Example (Singleton): Ensures a class has only one instance and provides a global point of access to it.

```Java

public class Singleton {
    private static Singleton instance;

    private Singleton() {
        // Private constructor to prevent external instantiation
    }

    public static Singleton getInstance() {
        if (instance == null) {
            instance = new Singleton();
        }
        return instance;
    }
}
```

**2. Structural Design Patterns**

These patterns deal with object composition and relationships between objects, simplifying the structure of classes and
objects and improving flexibility.

**Types**: Adapter, Decorator, Facade, Composite, Bridge, Proxy, Flyweight.

Example (Adapter): Allows incompatible interfaces to work together by converting one interface into another.

```Java

// Target interface
interface EuropeanSocket {
    void plugInEuropean();
}

// Adaptee class
class UsPlug {
    void plugInUs() {
        System.out.println("Plugging into US socket");
    }
}

// Adapter class
class UsToEuropeanAdapter implements EuropeanSocket {
    private UsPlug usPlug;

    public UsToEuropeanAdapter(UsPlug usPlug) {
        this.usPlug = usPlug;
    }

    @Override
    public void plugInEuropean() {
        usPlug.plugInUs(); // Adapt the call
    }
}
```

**3. Behavioral Design Patterns:**

These patterns focus on communication between objects and the assignment of responsibilities, managing how objects
interact to make the system more efficient and easier to modify.

**Types**: Observer, Strategy, Command, Template Method, Iterator, State, Chain of Responsibility, Mediator, Memento,
Visitor.

Example (Observer): Defines a one-to-many dependency between objects so that when one object changes state, all its
dependents are notified and updated automatically.

```Java

interface Observer {
    void update(String message);
}

class Subject {
    private List<Observer> observers = new ArrayList<>();
    private String state;

    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    public void setState(String newState) {
        this.state = newState;
        notifyAllObservers();
    }

    private void notifyAllObservers() {
        for (Observer observer : observers) {
            observer.update(state);
        }
    }
}

class ConcreteObserver implements Observer {
    private String name;

    public ConcreteObserver(String name) {
        this.name = name;
    }

    @Override
    public void update(String message) {
        System.out.println(name + " received update: " + message);
    }
}
```

## With use case, explain at least one design pattern from Creational, Structural & Behavioural types.

Here are explanations of one design pattern from each of the Creational, Structural, and Behavioral categories,
including a use case for each:

**Creational**: Singleton Pattern

The Singleton pattern ensures that a class has only one instance and provides a global point of access to that instance.

**Use Case**: A configuration manager for an application.

Imagine an application that needs to load various configuration settings from a file or database. It is crucial to
ensure that only one instance of the configuration manager exists throughout the application's lifecycle to maintain
consistency and avoid conflicting settings. The Singleton pattern ensures this by providing a single, globally
accessible instance of the ConfigurationManager class.

```Java

public class ConfigurationManager {
    private static ConfigurationManager instance;
    private String setting1;
    private int setting2;

    private ConfigurationManager() {
        // Private constructor to prevent direct instantiation
        // Load configurations here
        this.setting1 = "default_value";
        this.setting2 = 123;
    }

    public static synchronized ConfigurationManager getInstance() {
        if (instance == null) {
            instance = new ConfigurationManager();
        }
        return instance;
    }

    // Getters and setters for configuration settings
    public String getSetting1() {
        return setting1;
    }

    public int getSetting2() {
        return setting2;
    }
}
```

**Structural**: Adapter Pattern

The Adapter pattern allows incompatible interfaces to work together. It acts as a wrapper, converting the interface of
one class into another interface that clients expect.

**Use Case**: Integrating a new payment gateway into an existing e-commerce platform.

Consider an e-commerce platform that currently uses a specific payment gateway with its own API. If the platform needs
to integrate a new payment gateway with a different API, the Adapter pattern can be used. An PaymentGatewayAdapter can
be created to translate the calls from the existing platform's payment interface to the new gateway's specific API,
allowing the platform to seamlessly use the new gateway without modifying its core payment processing logic.

```Java

// Existing payment interface
public interface OldPaymentGateway {
    void processPayment(double amount);
}

// New payment gateway's specific API
public class NewPaymentService {
    public void makeTransaction(double amountInDollars) {
        System.out.println("Processing payment of $" + amountInDollars + " via NewPaymentService.");
    }
}

// Adapter to make NewPaymentService compatible with OldPaymentGateway
public class PaymentGatewayAdapter implements OldPaymentGateway {
    private NewPaymentService newService;

    public PaymentGatewayAdapter(NewPaymentService newService) {
        this.newService = newService;
    }

    @Override
    public void processPayment(double amount) {
        newService.makeTransaction(amount); // Adapt the call
    }
}
```

**Behavioral**: Strategy Pattern

The Strategy pattern defines a family of algorithms, encapsulates each one, and makes them interchangeable. It allows
the algorithm to vary independently from the clients that use it.

**Use Case**: Implementing different sorting algorithms in a data processing application.

Imagine a data processing application that needs to sort a list of items. Depending on the size of the data, performance
requirements, or specific data characteristics, different sorting algorithms (e.g., Bubble Sort, Quick Sort, Merge Sort)
might be more suitable. The Strategy pattern allows defining these sorting algorithms as separate strategies and
dynamically choosing which one to use at runtime.

```Java

// Strategy interface
public interface SortStrategy {
    void sort(int[] data);
}

// Concrete Strategy: Bubble Sort
public class BubbleSortStrategy implements SortStrategy {
    @Override
    public void sort(int[] data) {
        System.out.println("Sorting using Bubble Sort.");
        // Bubble sort implementation
    }
}

// Concrete Strategy: Quick Sort
public class QuickSortStrategy implements SortStrategy {
    @Override
    public void sort(int[] data) {
        System.out.println("Sorting using Quick Sort.");
        // Quick sort implementation
    }
}

// Context class that uses a SortStrategy
public class DataSorter {
    private SortStrategy strategy;

    public void setSortStrategy(SortStrategy strategy) {
        this.strategy = strategy;
    }

    public void performSort(int[] data) {
        strategy.sort(data);
    }
}
```

## What is the best way to implement Singleton Design Pattern?

The best way to implement the Singleton Design Pattern involves a private constructor, a private static final instance
of the class, and a public static getInstance() method, with the most robust, modern approach often being the Bill Pugh
Singleton (using a static inner class) for thread safety and lazy loading.

## What it is solid?

SOLID in Java refers to a set of five object-oriented design principles that aim to make software designs more
understandable, flexible, and maintainable. These principles are:

S: ingle Responsibility Principle (SRP)
O: pen/Closed Principle (OCP)
L: iskov Substitution Principle (LSP)
I: nterface Segregation Principle (ISP)
D: ependency Inversion Principle (DIP)

Here's an example illustrating the Single Responsibility Principle (SRP), which states that a class should have only one
reason to change, meaning it should have only one responsibility.

Example: Violating SRP

Consider a BankService class that handles multiple functionalities:

```Java

class BankService {
    public void deposit(double amount) {
        // Logic for depositing money
        System.out.println("Deposited: " + amount);
    }

    public void withdraw(double amount) {
        // Logic for withdrawing money
        System.out.println("Withdrew: " + amount);
    }

    public void printPassbook() {
        // Logic for printing passbook
        System.out.println("Printing passbook...");
    }

    public double getLoanInterestInfo() {
        // Logic for calculating loan interest
        return 0.05; // Example interest rate
    }

    public void sendOTP(String phoneNumber) {
        // Logic for sending OTP
        System.out.println("OTP sent to: " + phoneNumber);
    }
}
```

This BankService class violates SRP because it has multiple responsibilities: managing transactions, handling passbook
printing, providing loan information, and sending notifications. If the logic for sending OTP changes, or the loan
interest calculation method needs modification, or the passbook printing format is updated, this single BankService
class would need to be changed for different reasons.

Example: Adhering to SRP

To adhere to SRP, these responsibilities should be separated into distinct classes:

```Java

class TransactionService {
    public void deposit(double amount) {
        // Logic for depositing money
        System.out.println("Deposited: " + amount);
    }

    public void withdraw(double amount) {
        // Logic for withdrawing money
        System.out.println("Withdrew: " + amount);
    }
}

class PassbookPrinter {
    public void printPassbook() {
        // Logic for printing passbook
        System.out.println("Printing passbook...");
    }
}

class LoanService {
    public double getLoanInterestInfo() {
        // Logic for calculating loan interest
        return 0.05; // Example interest rate
    }
}

class NotificationService {
    public void sendOTP(String phoneNumber) {
        // Logic for sending OTP
        System.out.println("OTP sent to: " + phoneNumber);
    }
}
```

Now, each class has a single, well-defined responsibility, making the code more organized, easier to understand, and
less prone to issues when changes are required in one specific area.

## What are different design principles? Can you specify any 4 design principles apart from the SOLID design principles?

Design principles are fundamental guidelines for creating effective compositions, covering visual aspects like balance,
contrast, emphasis, rhythm, unity, repetition, and movement, while software design principles, beyond SOLID, include
concepts like DRY, KISS, YAGNI, focusing on code clarity, maintainability, and avoiding redundancy, such as the Gang of
Four (GoF) patterns (Adapter, Facade) and DRY (Don't Repeat Yourself), KISS (Keep It Simple, Stupid), YAGNI (You Ain't
Gonna Need It), and Law of Demeter.

**4 Design Principles (Non-SOLID)**

**DRY (Don't Repeat Yourself)**: A principle in software development stating that "Every piece of knowledge must have a
single, unambiguous, authoritative representation within a system". This means avoiding duplicate code for easier
maintenance and fewer bugs.

**KISS (Keep It Simple, Stupid)**: Advocates for simplicity in design, suggesting that most systems work best if they
are kept simple rather than made complex. Simpler solutions are often more reliable and easier to understand.

**YAGNI (You Ain't Gonna Need It)**: A principle from Extreme Programming (XP) that says a developer should not add
functionality until it is actually needed. This prevents over-engineering and building features that might never be
used.

**Law of Demeter (LoD)**: Also known as the Principle of Least Knowledge, it states that an object should only talk to
its immediate friends (objects it was created with, passed to it, or that are its direct components), reducing coupling.

## Give example of decorator design pattern in Java? Does it operate on object level or class level?

The Decorator design pattern is a structural pattern that allows adding new functionalities to an object dynamically
without altering its structure. It operates at the object level.

Here's an example in Java using a coffee shop scenario:

```Java

// Component Interface
interface Coffee {
    String getDescription();

    double getCost();
}

// Concrete Component
class SimpleCoffee implements Coffee {
    @Override
    public String getDescription() {
        return "Simple Coffee";
    }

    @Override
    public double getCost() {
        return 2.0;
    }
}

// Abstract Decorator
abstract class CoffeeDecorator implements Coffee {
    protected Coffee decoratedCoffee;

    public CoffeeDecorator(Coffee decoratedCoffee) {
        this.decoratedCoffee = decoratedCoffee;
    }

    @Override
    public String getDescription() {
        return decoratedCoffee.getDescription();
    }

    @Override
    public double getCost() {
        return decoratedCoffee.getCost();
    }
}

// Concrete Decorators
class MilkDecorator extends CoffeeDecorator {
    public MilkDecorator(Coffee decoratedCoffee) {
        super(decoratedCoffee);
    }

    @Override
    public String getDescription() {
        return super.getDescription() + ", Milk";
    }

    @Override
    public double getCost() {
        return super.getCost() + 0.5;
    }
}

class SugarDecorator extends CoffeeDecorator {
    public SugarDecorator(Coffee decoratedCoffee) {
        super(decoratedCoffee);
    }

    @Override
    public String getDescription() {
        return super.getDescription() + ", Sugar";
    }

    @Override
    public double getCost() {
        return super.getCost() + 0.2;
    }
}

// Client Code
public class CoffeeShop {
    public static void main(String[] args) {
        Coffee myCoffee = new SimpleCoffee();
        System.out.println("Description: " + myCoffee.getDescription() + ", Cost: $" + myCoffee.getCost());

        myCoffee = new MilkDecorator(myCoffee); // Decorate with milk
        System.out.println("Description: " + myCoffee.getDescription() + ", Cost: $" + myCoffee.getCost());

        myCoffee = new SugarDecorator(myCoffee); // Decorate with sugar
        System.out.println("Description: " + myCoffee.getDescription() + ", Cost: $" + myCoffee.getCost());

        Coffee anotherCoffee = new MilkDecorator(new SugarDecorator(new SimpleCoffee()));
        System.out.println("Description: " + anotherCoffee.getDescription() + ", Cost: $" + anotherCoffee.getCost());
    }
}
```

## What is façade design pattern and its usage?

The Facade design pattern provides a simplified, unified interface to a complex subsystem of classes, acting as a single
entry point that hides internal implementation details and makes the system easier to use and maintain, much like a
building's front (facade) hides its complex structure. Its usage involves reducing complexity for clients, enabling
easier interaction with large libraries or frameworks, abstracting platform specifics, and improving code cleanliness
and testability by offering a high-level, cohesive view of functionality.

**How it Works**

**Single Entry Point**: A facade class encapsulates many underlying classes and methods, presenting a simpler API.

**Hides Complexity**: Clients interact only with the facade, unaware of the many steps or classes involved in the
complex subsystem.

**Decouples Client**: It reduces tight coupling between the client code and the intricate subsystem, making changes
easier.

**Key Usages & Benefits**

Simplifying Libraries/Frameworks: Makes complex APIs (like database management, file systems, networking) more
accessible.

**System Initialization**: Handles complex setup and configuration within a single call.
Microservices & APIs: An API gateway or a dedicated service can act as a facade to orchestrate calls to multiple
microservices.

**Cross-Platform Development**: Abstracts platform-specific differences (iOS, Android) into a unified interface.

**Testing**: Facilitates unit testing by allowing facades to be mocked or stubbed, isolating the code under test.

**Code Organization**: Keeps business logic clean by separating it from complex infrastructure code.
Real-World Analogy

**Restaurant**: A waiter (facade) takes your simple order (menu item), hiding the complex process of the kitchen (
subsystem) to cook the food.

## What is flyweight design pattern and where is it used in JAVA API? (String Memory allocation).

The Flyweight design pattern is a structural pattern focused on minimizing memory usage by sharing common parts of
object state among multiple objects. It achieves this by separating an object's state into two categories:

**Intrinsic State**: This is the immutable, shared state that can be reused across many flyweight objects. It's stored
within the flyweight object itself.

**Extrinsic State**: This is the mutable, context-specific state that cannot be shared. It's passed to the flyweight's
methods as needed, rather than being stored within the flyweight object.

**Where it's used in Java API (String Memory Allocation)**

The most prominent example of the Flyweight pattern in the Java API related to memory allocation is the String Pool.

String Pool and Flyweight: When you create String literals in Java (e.g., String s = "hello";), the Java Virtual
Machine (JVM) checks the String Pool. If a String with the same value already exists in the pool, a reference to that
existing String object is returned instead of creating a new one. This shared String object acts as the "flyweight."

Intrinsic and Extrinsic State in Strings:

Intrinsic State: The actual character data of the String (e.g., "hello") is the intrinsic state, which is shared and
immutable.

Extrinsic State: While Strings themselves are immutable, if you consider scenarios where String objects are part of a
larger context (like a list of names for different users), the user-specific data associated with each name would be the
extrinsic state.

Integer Caching (Autoboxing).
While not directly part of the String class, the Integer wrapper class in Java also utilizes a form of Flyweight
pattern. When autoboxing occurs for Integer values between -128 and 127 (inclusive), the JVM caches these Integer
objects. This means that if you create multiple Integer objects with the same value within this range, they will often
refer to the same cached instance, saving memory.
Java

    Integer i1 = 100; // Autoboxing, uses cached Integer
    Integer i2 = 100; // Autoboxing, uses the same cached Integer
    Integer i3 = 200; // Outside the cache range, new Integer object created
    Integer i4 = 200; // Outside the cache range, new Integer object created

    System.out.println(i1 == i2); // true
    System.out.println(i3 == i4); // false (typically)

In summary, the Flyweight pattern, or principles similar to it, are used in the Java API to optimize memory usage,
particularly in the handling of String literals through interning and in the caching of Integer objects during
autoboxing.

Benefits in String Memory Allocation:

By utilizing the String Pool and the Flyweight pattern, Java significantly reduces memory consumption by avoiding the
creation of duplicate String objects, especially in applications that frequently use the same String literals. This
optimizes memory usage and can improve performance by reducing garbage collection overhead.

