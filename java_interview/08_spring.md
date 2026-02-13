# Spring
Spring and SpringBoot Framework.

# Why will you choose Spring Boot over Spring Framework?

1. Dependency resolution / Avoiding version conflit<br>
2. Avoiding addtional configuration<br>
3. Embed Tomcat, Jetty (no need to deploy WAR files)<br>
4. Provide production-ready features such as metrics, health checks, etc<br>

# What is the purpose of the @SpringBootApplication annotation?

It contains these three annotations:<br>

1. @EnableAutoConfiguration<br>
2. @ComponentScan<br>
3. @Configuration<br>

# What is difference between @bean and @component in spring?<br>

In Spring, both @Bean and @Component annotations are used to define and manage beans within the Spring IoC container, but they differ in their usage and the level of control they provide:<br>

***@Component:***<br>
**Purpose**: Marks a class as a Spring-managed component, making it eligible for automatic detection through component scanning.<br>

**Usage**: Applied at the class level.

**Control**: Offers less direct control over bean creation and configuration, relying on Spring's default instantiation and dependency injection mechanisms.<br>

**Example:**
```java

    @Component
    public class MyService {
        // ...
    }
```

***Specializations:*** Has specialized stereotype annotations like @Service, @Repository, and @Controller, which are essentially specialized forms of @Component with additional semantic meaning.<br>

***@Bean:***<br>
**Purpose:** Explicitly declares a method as a bean producer, returning an object that Spring should register as a bean in the application context.<br>

**Usage:** Applied at the method level within a @Configuration class.<br>

**Control:** Provides fine-grained control over bean creation, allowing for custom instantiation logic, configuration, and dependency resolution within the method.<br>

Example<br>

```Java

@Configuration
public class AppConfig {
    @Bean
    public MyBean myCustomBean() {
        // Custom initialization logic
        return new MyBean();
    }
}
```

**Flexibility:** Useful for integrating third-party libraries or when complex initialization or configuration is required for a bean.<br>

# Explain the way you are doing transaction management and error handling.

Spring transaction management, most effectively implemented using the @Transactional annotation (declarative approach), ensures that a series of database operations succeed or fail as a single atomic unit to maintain data integrity.<br>

Error handling relies on Spring's default rollback behavior for unchecked exceptions, which can be customized as needed.<br>


**Spring Transaction Management**<br>


Spring provides two primary methods for transaction management:<br>

***Declarative Transaction Management (Best Approach for Most Cases):***<br>

This is the most common and recommended approach, using the @Transactional annotation on service layer methods or classes. It separates transaction logic from business logic, reducing boilerplate code. Spring uses AOP (Aspect-Oriented Programming) proxies to manage the transaction lifecycle (start, commit, rollback) behind the scenes. In a Spring Boot application with the appropriate dependencies, transaction management is enabled by default.<br>

***Programmatic Transaction Management:***<br>
 This offers fine-grained control using the PlatformTransactionManager interface or TransactionTemplate. It is suitable for complex or dynamic scenarios but results in more cluttered code and is generally less preferred than the declarative approach.<br>

**Error Handling and Rollback**<br>

By default, Spring's declarative transaction management follows these rules for error handling:<br>

**Rollback on Unchecked Exceptions**: The transaction is automatically rolled back if an unchecked exception (subclass of RuntimeException or Error) is thrown. This is the standard behavior for most application errors.<br>

**Commit on Checked Exceptions**: The transaction is committed if a checked exception is thrown, as these are typically considered recoverable business exceptions that do not necessarily warrant a full rollback.<br>

You can customize this behavior using attributes in the @Transactional annotation:<br>

**rollbackFor**: Specifies which checked exceptions should trigger a rollback.<br>

**noRollbackFor**: Specifies which unchecked exceptions should not trigger a rollback.<br>

Best Approach and Concrete Example<br>

The best approach is to use the @Transactional annotation in the service layer to define transaction boundaries, leveraging Spring's default behavior for most errors and customizing with rollbackFor for specific checked exceptions.<br>

**Example**: Money Transfer Service<br>

Consider a banking service that transfers money between two accounts. This operation involves two database updates that must be atomic.<br>

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AccountService {

    @Autowired
    private AccountRepository accountRepository;

    /**
     * Transfers a specified amount from one account to another.
     * The entire operation is a single transaction.
     */
    @Transactional(rollbackFor = {InsufficientFundsException.class, BankTransactionException.class})
    public void transferMoney(Long fromAccountId, Long toAccountId, double amount)
            throws InsufficientFundsException, BankTransactionException {

        // Step 1: Deduct from the source account
        Account fromAccount = accountRepository.findById(fromAccountId)
                .orElseThrow(() -> new BankTransactionException("Source account not found"));

        if (fromAccount.getBalance() < amount) {
            throw new InsufficientFundsException("Insufficient funds in source account");
        }

        fromAccount.setBalance(fromAccount.getBalance() - amount);
        accountRepository.save(fromAccount);

        // Step 2: Add to the destination account
        Account toAccount = accountRepository.findById(toAccountId)
                .orElseThrow(() -> new BankTransactionException("Destination account not found"));

        toAccount.setBalance(toAccount.getBalance() + amount);
        accountRepository.save(toAccount);

        // If both steps succeed, the transaction is committed automatically.
        // If any RuntimeException (like the ones thrown above) occurs, 
        // or the specified checked exceptions occur, the transaction rolls back.
    }
}
```

In this example, InsufficientFundsException and BankTransactionException are custom checked exceptions. By using rollbackFor in the @Transactional annotation, we ensure that if either exception is thrown, all changes to both accounts are rolled back, keeping the database in a consistent state.<br>

Key Best Practices:<br>

Place @Transactional on public methods in the service layer.<br>
Ensure exceptions that should cause a rollback are either unchecked (RuntimeException) or explicitly specified using rollbackFor.<br>

Avoid catching exceptions inside a @Transactional method without rethrowing them, as this will prevent the transaction from rolling back.<br>

For read-only operations, use @Transactional(readOnly = true) for potential performance optimization.<br>

### if a method annotated call a non annotated method in the same class and this method occurs an error, what behavior should has?<br>

When a method annotated with @Transactional calls another method within the same object that is not annotated with @Transactional, and the non-annotated method throws an exception, the behavior depends on whether the exception is caught and handled within the non-annotated method or rethrown.<br>

Scenario 1: Exception is caught and handled within the non-annotated method.<br>
If the non-annotated method catches the exception and does not rethrow it, the @Transactional method will not be aware of the error.<br>

The transaction will proceed as if no error occurred, potentially leading to a commit if no other exceptions are thrown.<br>

This can result in an inconsistent state where the database reflects a successful operation even though an error occurred during a sub-operation.<br>

Scenario 2: Exception is rethrown by the non-annotated method or is an unchecked exception (RuntimeException or Error) that is not caught.<br>

If the non-annotated method rethrows the exception, or if it's an unchecked exception that propagates up the call stack, the @Transactional method will receive the exception.<br>

By default, Spring's @Transactional annotation rolls back the transaction on any RuntimeException or Error.<br>

If the rethrown exception is a RuntimeException or Error, the entire transaction managed by the @Transactional method will be rolled back, ensuring data consistency.<br>

If the rethrown exception is a checked exception, the transaction will not be rolled back by default, unless the @Transactional annotation is configured with rollbackFor to include that specific checked exception type.<br>

Key takeaway: For proper transaction management, if a non-transactional method called from within a transactional method encounters an error that should trigger a rollback, it must either rethrow a RuntimeException or Error, or rethrow a checked exception that is explicitly configured in the @Transactional annotation's rollbackFor property. Catching and suppressing exceptions within the non-annotated method can lead to unexpected and potentially problematic transaction outcomes.

# Can i use @transacation spring annotation in a private method?

No, the @Transactional annotation in Spring will not work on private methods in the default proxy-based AOP mode.<br>

Spring's transaction management, when using @Transactional, relies on AOP proxies. These proxies intercept method calls to apply transactional behavior (like starting, committing, or rolling back a transaction). However, proxies can only intercept calls to public methods. Private methods are not accessible through the proxy and can only be called internally within the same object, meaning Spring cannot intercept these calls to apply transaction management.<br>

While annotating a private method with @Transactional will not cause a compilation or runtime error, it will not have any transactional effect. This can lead to unexpected behavior, such as partial updates in the database if an exception occurs within the private method.<br>

# What is the Bean lifeCycle in SpringBeanFactory Container and what are the callback methods?

The Spring Bean life cycle describes the sequence of events that occur from the time a bean is instantiated by the Spring IoC container until it is destroyed. This process allows for custom logic to be executed at various stages of a bean's existence.<br>

**Spring Bean Life Cycle Stages**:<br>

**Bean Definition Acquisition**: The container reads the bean definitions from configuration (XML, annotations, Java config).<br>

**Bean Instantiation**: The container instantiates the bean (e.g., using a constructor). Populating Properties (Dependency Injection): The container injects dependencies into the bean's properties.<br>

BeanNameAware / BeanFactoryAware / ApplicationContextAware Callbacks: If the bean implements these interfaces, the respective setBeanName(), setBeanFactory(), or setApplicationContext() methods are called.<br>

BeanPostProcessor (postProcessBeforeInitialization): BeanPostProcessor implementations can modify the bean before its initialization methods are called.<br>

Initialization Callbacks:<br>
If the bean implements InitializingBean, its afterPropertiesSet() method is called.<br>
If an init-method is specified in the configuration, that method is called.<br>
If @PostConstruct is used, the annotated method is called.<br>

BeanPostProcessor (postProcessAfterInitialization): BeanPostProcessor implementations can modify the bean after its initialization methods are called.<br>

Ready for Use: The bean is now fully initialized and ready for use by the application.<br>

Destruction Callbacks: When the container is shut down:<br>
If the bean implements DisposableBean, its destroy() method is called.<br>
If a destroy-method is specified in the configuration, that method is called.<br>
If @PreDestroy is used, the annotated method is called.<br>

Callback Methods in Spring:<br>

Spring provides various ways to hook into the bean life cycle using callback methods:<br>

Interface-based Callbacks:<br>

InitializingBean: Implement afterPropertiesSet() for post-initialization logic.<br>

DisposableBean: Implement destroy() for pre-destruction cleanup logic.<br>

Configuration-based Callbacks:<br>

init-method attribute: Specify a method to be called after property setting and before use.<br>

destroy-method attribute: Specify a method to be called before the bean is removed from the container.<br>

Annotation-based Callbacks:<br>

@PostConstruct: Annotate a method to be called after dependency injection and initialization.<br>

@PreDestroy: Annotate a method to be called before the bean's destruction.<br>

Aware Interfaces:<br>

BeanNameAware: setBeanName(String name) to get the bean's ID.<br>
BeanFactoryAware: setBeanFactory(BeanFactory beanFactory) to get a reference to the BeanFactory.<br>
ApplicationContextAware: setApplicationContext(ApplicationContext applicationContext) to get a reference to the ApplicationContext.<br>

BeanPostProcessor: Provides postProcessBeforeInitialization() and postProcessAfterInitialization() methods to customize beans before and after initialization.<br>

# What is Spring IoC Container?

The **Spring IoC (Inversion of Control) Container** is the core component of the Spring Framework responsible for:<br>

- Creating objects (beans)<br>
- Managing their lifecycle<br>
- Injecting dependencies (Dependency Injection)<br>
- Configuring them based on metadata (XML, annotations, Java config)<br>

Instead of objects creating their dependencies, the container provides them.<br>
This promotes loose coupling and easier testing.<br>

Example:<br>

```java
@Component
public class OrderService {
    private final PaymentService paymentService;

    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

# Difference Between BeanFactory and ApplicationContext

***Overview***<br>

Both **BeanFactory** and **ApplicationContext** are IoC containers in Spring.<br>
However, `ApplicationContext` is an advanced and feature-rich extension of `BeanFactory`.<br>

---

***Key Differences***<br>

| Feature | BeanFactory | ApplicationContext |
|----------|------------|-------------------|
| Type | Basic IoC container | Advanced IoC container |
| Bean loading | Lazy by default | Eager by default (for singletons) |
| Dependency Injection | Yes | Yes |
| AOP support | Limited | Full support |
| Event publishing | No | Yes |
| Internationalization (i18n) | No | Yes |
| Environment abstraction | No | Yes |
| Recommended for modern apps | No | Yes |

---

***BeanFactory***<br>

- Minimal container.<br>
- Instantiates beans only when requested.<br>
- Suitable for memory-constrained environments (rare today).<br>
- Mostly internal usage in modern Spring applications.<br>

---

***ApplicationContext***<br>

- Extends `BeanFactory`.<br>
- Pre-instantiates singleton beans at startup.<br>
- Supports enterprise features such as:<br>
  - Event handling<br>
  - Message resource (i18n)<br>
  - AOP integration<br>
  - Environment profiles<br>

Used in almost all Spring and Spring Boot applications.<br>

---

***Interview Summary***<br>

> BeanFactory provides basic dependency injection, while ApplicationContext builds on top of it by adding enterprise-level features and is the standard container used in real-world applications.<br>


# What is the Default Scope of Beans in Spring?<br>

The **default scope** of a Spring bean is:<br>

> **Singleton**<br>

This means only **one instance per Spring IoC container** is created and shared across the entire application context.<br>

Important:  <br>
Spring Singleton ≠ GoF Singleton  <br>
(Spring creates one instance per container, not per JVM.)<br>

---

# All Bean Scopes in Spring

***1️⃣ Singleton (Default)***<br>

- One instance per IoC container.<br>
- Shared across the application.<br>
- Created at container startup (by default).<br>

```java
@Scope("singleton")
```

Use when:<br>

Stateless services<br>

Shared components<br>

Service/Repository layers<br>

***2️⃣ Prototype***<br>

A new instance is created every time the bean is requested.<br>

Spring does not manage the full lifecycle after creation.<br>
```java
@Scope("prototype")
```

Use when:<br>

Stateful objects<br>

Short-lived objects<br>

⚠ If injected into a singleton, only one instance is created at injection time unless using ObjectFactory/Provider.<br>

***3️⃣ Request (Web Scope)***<br>

One instance per HTTP request.<br>

Available only in web-aware applications.<br>
```java
@Scope(value = WebApplicationContext.SCOPE_REQUEST)
```

Use when:<br>

Request-specific data<br>

Per-request processing state<br>

***4️⃣ Session (Web Scope)***<br>

One instance per HTTP session.<br>
```java
@Scope(value = WebApplicationContext.SCOPE_SESSION)
```

Use when:<br>

User session data<br>

Shopping cart scenarios<br>

***5️⃣ Application (Web Scope)***<br>

One instance per ServletContext.<br>

Shared across the entire web application.<br>
```java
@Scope(value = WebApplicationContext.SCOPE_APPLICATION)
```

Use when:<br>

Shared web-level resources<br>

***6️⃣ WebSocket (Web Scope)***<br>

One instance per WebSocket session.<br>
```java
@Scope(value = WebApplicationContext.SCOPE_WEBSOCKET)
```

Use when:<br>

Real-time WebSocket communication state<br>

***Summary Table***<br>

| Scope       | Lifecycle                      | Typical Usage              |
|------------|--------------------------------|----------------------------|
| Singleton  | One per container              | Services, repositories     |
| Prototype  | New per container request      | Stateful components        |
| Request    | One per HTTP request           | Request-specific data      |
| Session    | One per HTTP session           | User-specific session state|
| Application| One per web application        | Shared web resources       |
| WebSocket  | One per WebSocket session      | Real-time applications     |

***Interview Summary***<br>

> The default scope in Spring is Singleton. Other scopes define how and when bean instances are created and managed depending on application context (standard or web-aware).<br>


# Difference between singleton scope bean and singleton class?

The distinction between a Spring singleton-scoped bean and a Java singleton class lies in their scope and enforcement of
the "single instance" concept.

1. Java Singleton Class:
   A Java singleton class enforces the creation of only one instance of that class within a single Java ClassLoader.
   This is achieved through specific design patterns, often involving a private constructor and a static method to
   provide access to the single instance.
   Java

public class MyJavaSingleton {
private static MyJavaSingleton instance;

    private MyJavaSingleton() {
        // Private constructor to prevent external instantiation
    }

    public static MyJavaSingleton getInstance() {
        if (instance == null) {
            instance = new MyJavaSingleton();
        }
        return instance;
    }

}

2. Spring Singleton-Scoped Bean:
   A Spring singleton-scoped bean, on the other hand, means that the Spring IoC container will create only one instance
   of that bean definition per container. Every time the bean is requested from the same Spring container, the same
   instance is returned. While it's the default scope for Spring beans, it doesn't prevent manual instantiation of the
   class outside the Spring container.
   Java

@Component
@Scope("singleton") // This is the default, so it can be omitted
public class MySpringSingletonBean {
public MySpringSingletonBean() {
System.out.println("MySpringSingletonBean instance created!");
}
}
Key Differences:
Scope of Uniqueness: A Java singleton guarantees one instance per classloader, while a Spring singleton bean guarantees
one instance per Spring IoC container.
Enforcement: Java singletons enforce their single instance constraint through code (e.g., private constructor). Spring
singletons are managed by the container, and while the container provides only one instance, it doesn't prevent
external, manual instantiation of the class.
Flexibility: Spring's singleton scope offers more flexibility as you can easily change a bean's scope (e.g., to
prototype) without modifying the class itself, whereas changing a Java singleton requires altering the class's design.
Testing: Spring singletons are generally easier to test because they can be mocked or replaced within the Spring
context, unlike tightly coupled Java singletons.


# Difference Between @Controller and @RestController

***@Controller***<br>

- Used in traditional Spring MVC applications.<br>
- Returns **View names** (e.g., JSP, Thymeleaf).<br>
- Requires `@ResponseBody` to return JSON/XML.<br>

Example:<br>

```java
@Controller
public class UserController {

    @GetMapping("/user")
    public String getUser(Model model) {
        model.addAttribute("name", "John");
        return "user-view"; // resolves to a view template
    }
}
```

If returning JSON:<br>
```java
@ResponseBody
@GetMapping("/api/user")
public User getUser() {
    return new User("John");
}
```

***@RestController***<br>

Specialized version of @Controller.<br>

Combines:<br>

@Controller<br>

@ResponseBody<br>

Returns data (JSON/XML) directly.<br>

Used for REST APIs.<br>

Example:<br>
```java
@RestController
public class UserController {

    @GetMapping("/api/user")
    public User getUser() {
        return new User("John");
    }
}
```

No need for @ResponseBody.<br>

***Key Difference***<br>

| Feature               | @Controller                     | @RestController        |
|-----------------------|----------------------------------|------------------------|
| Returns View          | Yes                              | No                     |
| Returns JSON directly | No (needs @ResponseBody)         | Yes                    |
| Used for REST APIs    | Not typically                    | Yes                    |
| Annotation type       | MVC controller                   | REST controller        |


Interview Summary<br>

@RestController is a convenience annotation that combines @Controller and @ResponseBody, making it ideal for REST APIs that return JSON/XML instead of views.<br>

# What is Dependency Injection (DI)?

Dependency Injection is a design pattern in which an object's dependencies are provided by an external container instead of being created by the object itself.<br>

It is a core concept of the Spring IoC container and promotes:<br>

- Loose coupling<br>
- Better testability<br>
- Separation of concerns<br>

Instead of:<br>

```java
public class OrderService {
    private PaymentService paymentService = new PaymentService();
}
```

We use DI:<br>
```java
public class OrderService {
    private final PaymentService paymentService;

    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

Types of Dependency Injection in Spring<br>

***1️⃣ Constructor Injection***<br>

Dependencies are provided through the constructor.<br>
```java
@Component
public class OrderService {

    private final PaymentService paymentService;

    public OrderService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

✔ Recommended approach<br>
✔ Ensures required dependencies<br>
✔ Enables immutability<br>
✔ Easier unit testing<br>

***2️⃣ Setter Injection***<br>

Dependencies are provided through setter methods.<br>
```java
@Component
public class OrderService {

    private PaymentService paymentService;

    @Autowired
    public void setPaymentService(PaymentService paymentService) {
        this.paymentService = paymentService;
    }
}
```

✔ Useful for optional dependencies<br>
✔ Allows reconfiguration<br>

***3️⃣ Field Injection (Not Recommended)***<br>

Dependencies are injected directly into fields.<br>
```java
@Autowired
private PaymentService paymentService;
```

❌ Harder to test<br>
❌ Breaks immutability<br>
❌ Hides dependencies<br>

When to Use Constructor vs Setter Injection<br>
Use Constructor Injection When:<br>

Dependency is mandatory<br>

Class should be immutable<br>

You want safer design<br>

You want better testability<br>

Best for:<br>

Services<br>

Core business components<br>

Use Setter Injection When:<br>

Dependency is optional<br>

You need to change dependency later<br>

Circular dependencies must be resolved (though redesign is preferred)<br>

***Interview Summary***<br>

Dependency Injection allows the container to provide object dependencies instead of the object creating them. Constructor injection is preferred for mandatory dependencies and immutability, while setter injection is suitable for optional dependencies.<br>

The container injects PaymentService.

# What is Aspect, Advice, Pointcut, JointPoint and Advice Arguments in AOP?

In Spring AOP, the following concepts are fundamental:<br>

**Aspect:** An aspect is a modularization of a crosscutting concern, such as logging, security, or transaction management. It encapsulates the advice and pointcuts related to a specific concern. In Spring, an aspect is typically a class annotated with *@Aspect*.<br>

**Advice:** Advice defines the action taken by an aspect at a particular join point. It specifies what to do and when to do it. Common types of advice include:<br>

*@Before:* Executes before a join point.<br>

*@AfterReturning:* Executes after a join point completes normally.<br>

*@AfterThrowing:* Executes if a join point exits by throwing an exception.<br>

*@After:* Executes regardless of how a join point exits (normal or exceptional).<br>

*@Around:* Surrounds a join point, allowing custom behavior before and after the method invocation, and the ability to control whether to proceed to the join point or shortcut its execution.<br>

**Pointcut:** A pointcut is a predicate that matches join points and determines where advice should be applied. It uses an expression language (often AspectJ's pointcut expression language) to select specific execution points, like method executions with certain names, return types, or arguments.<br>

**JoinPoint:** A join point is a specific point during the execution of a program where an aspect can be plugged in. In Spring AOP, a join point always represents a method execution. When advice is triggered, a JoinPoint object (or ProceedingJoinPoint for @Around advice) is passed to the advice method, providing access to information about the method being executed, its arguments, and the target object.<br>

**Advice Arguments:** Advice arguments allow you to pass specific values from the join point to the advice method. This is achieved by using the args() pointcut designator within the pointcut expression, which binds arguments from the matched method signature to parameters in the advice method. For example, args(account, ..) in a pointcut expression can bind an Account object from the method's  arguments to an account parameter in the advice.<br>


# Use of @Required, @Autowired, @Resource & @Qualifier annotations

# How to stop loading some beans in application context at start up?
# How to resolve circular or cyclic dependency related issues like BeanCurrentlyInCreationException ?
# Why it’s better to avoid constructor injection if there is any cyclic dependency?
# How to Inject Prototype Scoped Bean in Singleton Bean so that the injected bean should behave like Prototype instead  of outer Singleton bean.
# Usage of ApplicationContextAware?


