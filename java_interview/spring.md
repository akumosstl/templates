# Spring
Spring and SpringBoot Framework.

# Why will you choose Spring Boot over Spring Framework?

1. Dependency resolution / Avoiding version conflit
2. Avoiding addtional configuration
3. Embed Tomcat, Jetty (no need to deploy WAR files)
4. Provide production-ready features such as metrics, health checks, etc

# What is the purpose of the @SpringBootApplication annotation?

It contains these three annotations:

1. @EnableAutoConfiguration
2. @ComponentScan
3. @Configuration

# What is difference between @bean and @component in spring?

In Spring, both @Bean and @Component annotations are used to define and manage beans within the Spring IoC container, but they differ in their usage and the level of control they provide:

***@Component:***
**Purpose**: Marks a class as a Spring-managed component, making it eligible for automatic detection through component scanning.

**Usage**: Applied at the class level.
Control: Offers less direct control over bean creation and configuration, relying on Spring's default instantiation and dependency injection mechanisms.

**Example:**
```java

    @Component
    public class MyService {
        // ...
    }
```

***Specializations:*** Has specialized stereotype annotations like @Service, @Repository, and @Controller, which are
essentially specialized forms of @Component with additional semantic meaning.

***@Bean:***
**Purpose:** Explicitly declares a method as a bean producer, returning an object that Spring should register as a bean in the application context.

**Usage:** Applied at the method level within a @Configuration class.

**Control:** Provides fine-grained control over bean creation, allowing for custom instantiation logic, configuration, and dependency resolution within the method.

Example

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

**Flexibility:** Useful for integrating third-party libraries or when complex initialization or configuration is required for a bean.

# What is Aspect, Advice, Pointcut, JointPoint and Advice Arguments in AOP?

In Spring AOP, the following concepts are fundamental:

**Aspect:** An aspect is a modularization of a crosscutting concern, such as logging, security, or transaction management.
It encapsulates the advice and pointcuts related to a specific concern. In Spring, an aspect is typically a class
annotated with *@Aspect*.

**Advice:** Advice defines the action taken by an aspect at a particular join point. It specifies what to do and when to do
it. Common types of advice include:

*@Before:* Executes before a join point.

*@AfterReturning:* Executes after a join point completes normally.

*@AfterThrowing:* Executes if a join point exits by throwing an exception.

*@After:* Executes regardless of how a join point exits (normal or exceptional).

*@Around:* Surrounds a join point, allowing custom behavior before and after the method invocation, and the ability to control whether to proceed to the join point or shortcut its execution.

**Pointcut:** A pointcut is a predicate that matches join points and determines where advice should be applied. It uses an expression language (often AspectJ's pointcut expression language) to select specific execution points, like method executions with certain names, return types, or arguments.

**JoinPoint:** A join point is a specific point during the execution of a program where an aspect can be plugged in. In Spring AOP, a join point always represents a method execution. When advice is triggered, a JoinPoint object (or ProceedingJoinPoint for @Around advice) is passed to the advice method, providing access to information about the method being executed, its arguments, and the target object.

**Advice Arguments:** Advice arguments allow you to pass specific values from the join point to the advice method. This is achieved by using the args() pointcut designator within the pointcut expression, which binds arguments from the matched method signature to parameters in the advice method. For example, args(account, ..) in a pointcut expression can bind an Account object from the method's 
arguments to an account parameter in the advice.

# Explain the way you are doing transaction management and error handling.

Spring transaction management, most effectively implemented using the @Transactional annotation (declarative approach), ensures that a series of database operations succeed or fail as a single atomic unit to maintain data integrity.

Error handling relies on Spring's default rollback behavior for unchecked exceptions, which can be customized as needed.


**Spring Transaction Management**


Spring provides two primary methods for transaction management:

Declarative Transaction Management (Best Approach for Most Cases):

This is the most common and recommended approach, using the @Transactional annotation on service layer methods or
classes. It separates transaction logic from business logic, reducing boilerplate code. Spring uses AOP (Aspect-Oriented
Programming) proxies to manage the transaction lifecycle (start, commit, rollback) behind the scenes. In a Spring Boot
application with the appropriate dependencies, transaction management is enabled by default.

Programmatic Transaction Management: This offers fine-grained control using the PlatformTransactionManager interface or
TransactionTemplate. It is suitable for complex or dynamic scenarios but results in more cluttered code and is generally
less preferred than the declarative approach.

**Error Handling and Rollback**

By default, Spring's declarative transaction management follows these rules for error handling:

**Rollback on Unchecked Exceptions**: The transaction is automatically rolled back if an unchecked exception (subclass
of RuntimeException or Error) is thrown. This is the standard behavior for most application errors.

**Commit on Checked Exceptions**: The transaction is committed if a checked exception is thrown, as these are typically
considered recoverable business exceptions that do not necessarily warrant a full rollback.

You can customize this behavior using attributes in the @Transactional annotation:

**rollbackFor**: Specifies which checked exceptions should trigger a rollback.

**noRollbackFor**: Specifies which unchecked exceptions should not trigger a rollback.
Best Approach and Concrete Example

The best approach is to use the @Transactional annotation in the service layer to define transaction boundaries,
leveraging Spring's default behavior for most errors and customizing with rollbackFor for specific checked exceptions.

**Example**: Money Transfer Service

Consider a banking service that transfers money between two accounts. This operation involves two database updates that
must be atomic.

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

In this example, InsufficientFundsException and BankTransactionException are custom checked exceptions. By using
rollbackFor in the @Transactional annotation, we ensure that if either exception is thrown, all changes to both accounts
are rolled back, keeping the database in a consistent state.

Key Best Practices:

Place @Transactional on public methods in the service layer.
Ensure exceptions that should cause a rollback are either unchecked (RuntimeException) or explicitly specified using
rollbackFor.

Avoid catching exceptions inside a @Transactional method without rethrowing them, as this will prevent the transaction
from rolling back.

For read-only operations, use @Transactional(readOnly = true) for potential performance optimization.

### Using @transaction, if a method annotated call a non annotated method in the same class and this method occurs an error, what behavior should has?

When a method annotated with @Transactional calls another method within the same object that is not annotated with @Transactional, and the non-annotated method throws an exception, the behavior depends on whether the exception is caught and handled within the non-annotated method or rethrown.

Scenario 1: Exception is caught and handled within the non-annotated method.
If the non-annotated method catches the exception and does not rethrow it, the @Transactional method will not be aware
of the error.
The transaction will proceed as if no error occurred, potentially leading to a commit if no other exceptions are thrown.
This can result in an inconsistent state where the database reflects a successful operation even though an error
occurred during a sub-operation.
Scenario 2: Exception is rethrown by the non-annotated method or is an unchecked exception (RuntimeException or Error)
that is not caught.
If the non-annotated method rethrows the exception, or if it's an unchecked exception that propagates up the call stack,
the @Transactional method will receive the exception.
By default, Spring's @Transactional annotation rolls back the transaction on any RuntimeException or Error.
If the rethrown exception is a RuntimeException or Error, the entire transaction managed by the @Transactional method
will be rolled back, ensuring data consistency.
If the rethrown exception is a checked exception, the transaction will not be rolled back by default, unless the
@Transactional annotation is configured with rollbackFor to include that specific checked exception type.
Key takeaway: For proper transaction management, if a non-transactional method called from within a transactional method
encounters an error that should trigger a rollback, it must either rethrow a RuntimeException or Error, or rethrow a
checked exception that is explicitly configured in the @Transactional annotation's rollbackFor property. Catching and
suppressing exceptions within the non-annotated method can lead to unexpected and potentially problematic transaction
outcomes.

## 3.2 Can i use @transacation spring annotation in a private method?

No, the @Transactional annotation in Spring will not work on private methods in the default proxy-based AOP mode.
Spring's transaction management, when using @Transactional, relies on AOP proxies. These proxies intercept method calls
to apply transactional behavior (like starting, committing, or rolling back a transaction). However, proxies can only
intercept calls to public methods. Private methods are not accessible through the proxy and can only be called
internally within the same object, meaning Spring cannot intercept these calls to apply transaction management.
While annotating a private method with @Transactional will not cause a compilation or runtime error, it will not have
any transactional effect. This can lead to unexpected behavior, such as partial updates in the database if an exception
occurs within the private method.

## 4. What is the Bean life cycle in Spring Bean Factory Container and what are the callback methods in Spring?

The Spring Bean life cycle describes the sequence of events that occur from the time a bean is instantiated by the
Spring IoC container until it is destroyed. This process allows for custom logic to be executed at various stages of a
bean's existence.

**Spring Bean Life Cycle Stages**:

Bean Definition Acquisition: The container reads the bean definitions from configuration (XML, annotations, Java
config).

Bean Instantiation: The container instantiates the bean (e.g., using a constructor).
Populating Properties (Dependency Injection): The container injects dependencies into the bean's properties.

BeanNameAware / BeanFactoryAware / ApplicationContextAware Callbacks: If the bean implements these interfaces, the
respective setBeanName(), setBeanFactory(), or setApplicationContext() methods are called.

BeanPostProcessor (postProcessBeforeInitialization): BeanPostProcessor implementations can modify the bean before its
initialization methods are called.

Initialization Callbacks:
If the bean implements InitializingBean, its afterPropertiesSet() method is called.
If an init-method is specified in the configuration, that method is called.
If @PostConstruct is used, the annotated method is called.

BeanPostProcessor (postProcessAfterInitialization): BeanPostProcessor implementations can modify the bean after its
initialization methods are called.

Ready for Use: The bean is now fully initialized and ready for use by the application.

Destruction Callbacks: When the container is shut down:
If the bean implements DisposableBean, its destroy() method is called.
If a destroy-method is specified in the configuration, that method is called.
If @PreDestroy is used, the annotated method is called.

Callback Methods in Spring:

Spring provides various ways to hook into the bean life cycle using callback methods:

Interface-based Callbacks:

InitializingBean: Implement afterPropertiesSet() for post-initialization logic.

DisposableBean: Implement destroy() for pre-destruction cleanup logic.

Configuration-based Callbacks:

init-method attribute: Specify a method to be called after property setting and before use.

destroy-method attribute: Specify a method to be called before the bean is removed from the container.

Annotation-based Callbacks:

@PostConstruct: Annotate a method to be called after dependency injection and initialization.

@PreDestroy: Annotate a method to be called before the bean's destruction.

Aware Interfaces:

BeanNameAware: setBeanName(String name) to get the bean's ID.
BeanFactoryAware: setBeanFactory(BeanFactory beanFactory) to get a reference to the BeanFactory.
ApplicationContextAware: setApplicationContext(ApplicationContext applicationContext) to get a reference to the
ApplicationContext.

BeanPostProcessor: Provides postProcessBeforeInitialization() and postProcessAfterInitialization() methods to customize
beans before and after initialization.

## 5. What is Spring IoC Container? What is the difference between BeanFactory and ApplicationContext?

The Spring IoC (Inversion of Control) Container is a core component of the Spring Framework, responsible for managing
the lifecycle of Java objects, known as "beans," within an application. It implements the Inversion of Control principle
by taking over the responsibility of object instantiation, configuration, and dependency management. This means that
instead of objects creating and managing their dependencies, the container injects these dependencies into the objects,
leading to loose coupling and increased testability.
Spring provides two main types of IoC containers: BeanFactory and ApplicationContext. Both interfaces represent the
Spring IoC container, but ApplicationContext is a more advanced and feature-rich extension of BeanFactory.
Here's the difference between BeanFactory and ApplicationContext:
BeanFactory:
Basic Functionality: It provides the fundamental features of the IoC container, such as bean instantiation, dependency
injection, and basic lifecycle management.
Lazy Initialization: By default, beans in a BeanFactory are instantiated only when they are explicitly requested, making
it lightweight and suitable for resource-constrained environments or simple applications.
Limited Features: It lacks many of the advanced features found in ApplicationContext.

**ApplicationContext**:

Extended Functionality: It extends BeanFactory and offers a wider range of enterprise-specific features.
Eager Initialization: By default, ApplicationContext instantiates and configures all singleton beans at startup, which
can lead to faster application startup times in some cases.
Advanced Features: It includes functionalities like:
Internationalization (I18n): Support for message resolution in different locales.
Event Propagation: Mechanism for publishing and subscribing to application-specific events.
Resource Loading: Ability to load resources from various locations (classpath, file system, URLs).
Integration with other Spring modules: Seamless integration with features like Aspect-Oriented Programming (AOP), web
applications, etc.
In summary, while BeanFactory provides the basic IoC container functionality, ApplicationContext is the preferred choice
for most modern Spring applications due to its comprehensive feature set and enhanced capabilities, especially for
enterprise-level development.

## 6. What is the default scope of beans in Spring? Explain all the scopes available in spring.

The default scope for beans in Spring is singleton. This means that for each bean definition within a Spring IoC
container, only a single instance of that bean will be created and shared across the entire application context.
Subsequent requests for that bean will return the same cached instance.

Here are all the scopes available in Spring:

Singleton (Default): A single instance of the bean is created and maintained per Spring IoC container. All requests for
this bean will receive the same instance. This is suitable for stateless beans or those where sharing a single instance
is desired.

Prototype: A new instance of the bean is created every time it is requested. This scope is appropriate for stateful
beans that should not be shared and require a fresh instance for each use.

Request (Web-aware only): A new instance of the bean is created for each HTTP request. This scope is typically used in
web applications where a bean's state needs to be specific to a single request.

Session (Web-aware only): A new instance of the bean is created for each HTTP session. This scope is used in web
applications to maintain bean state specific to a user's session.

Application (Web-aware only): A single instance of the bean is created for the entire duration of the ServletContext.
This is similar to the singleton scope but applies specifically to web applications and their servlet context.

WebSocket (Web-aware only): A new instance of the bean is created per WebSocket session. This scope is used in
applications leveraging WebSocket for real-time communication, where a bean's state needs to be tied to a specific
WebSocket connection.

## 7. Difference between singleton scope bean and singleton class?

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

# Diff: @Controller & @RestController?

The key difference between @Controller and @RestController in Spring lies in their intended use and how they handle the response body.<br>
@Controller:<br>
Used in traditional Spring MVC applications where the controller's primary role is to prepare data and return a view (
e.g., an HTML page rendered by a templating engine like Thymeleaf or JSP).
If a method within a @Controller needs to return raw data (like JSON or XML) directly in the response body, it must be
explicitly annotated with @ResponseBody.
@RestController:
A specialized version of @Controller specifically designed for building RESTful web services.
It is a convenience annotation that combines the functionality of @Controller and @ResponseBody. This means that every
method within a class annotated with @RestController automatically serializes its return value into the response body (
typically as JSON or XML), eliminating the need to add @ResponseBody to each method.
@RestController is ideal for creating APIs that primarily serve data to client applications (e.g., single-page
applications, mobile apps) rather than rendering full web pages.
In summary, choose @Controller when you need to return views in a traditional MVC application, and use @RestController
when building REST APIs that primarily return raw data directly in the response body.



8) What is dependency injection and the types? When to use Setter and when to use Constructor dependency injection.
9) What do you understand by auto wiring and name the different modes of it?
10) What’s the difference between @Component, @Controller, @Repository & @Service
    annotations in Spring?
11) Use of @Required, @Autowired, @Resource & @Qualifier annotations
12) How to stop loading some beans in application context at start up?
13) How to resolve circular or cyclic dependency related issues like
    BeanCurrentlyInCreationException ?
14) Why it’s better to avoid constructor injection if there is any cyclic dependency?
15) How to Inject Prototype Scoped Bean in Singleton Bean so that the injected bean should behave like Prototype instead
    of outer Singleton bean.
16) Usage of ApplicationContextAware?


