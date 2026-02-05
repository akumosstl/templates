### 11. How test a void method?

Testing void methods in Java typically involves verifying their side effects or using mocking frameworks to ensure
interactions with other components.

### 1. Testing Side Effects:

Since void methods do not return a value, their impact on the system must be observed through changes in state.

This can include:

Changes to object fields: If the void method modifies the internal state of an object, you can assert the new values of
those fields after the method call.

```java
    public class Counter {
    private int count = 0;

    public void increment() {
        count++;
    }

    public int getCount() {
        return count;
    }
}

// In your test:
Counter counter = new Counter();
    counter.

increment();

assertEquals(1,counter.getCount());
```

Interactions with external systems: If the void method interacts with a database, file system, or external service, you
can verify that these interactions occurred as expected. This often involves setting up test doubles (mocks or stubs)
for those external systems.
Exceptions: If the void method is expected to throw an exception under certain conditions, you can use JUnit's
assertThrows to verify this behavior.

```java
    // In your test:
assertThrows(IllegalArgumentException .class, () ->{
        myObject.

doSomethingInvalid(null);
    });

```

2. Using Mockito for Interaction Verification:
   Mockito is a popular mocking framework that allows you to verify interactions with mocked objects, which is
   particularly useful for void methods that interact with dependencies.
   Verify method calls: You can use Mockito.verify() to check if a void method on a mocked object was called, and even
   how many times it was called or with what arguments.

```java
    import static org.mockito.Mockito.*;

public class MyService {
    private MyRepository repository;

    public MyService(MyRepository repository) {
        this.repository = repository;
    }

    public void saveData(String data) {
        repository.save(data);
    }
}

public interface MyRepository {
    void save(String data);
}

// In your test:
MyRepository mockRepository = mock(MyRepository.class);
MyService service = new MyService(mockRepository);

    service.

saveData("test data");

verify(mockRepository, times(1)).

save("test data");

```

Stubbing void methods: You can use doNothing() or doThrow() with Mockito to control the behavior of void methods on
mocked objects when they are called during a test.

```java
    import static org.mockito.Mockito.*;

// ... (MyRepository and MyService as above)

// In your test:
MyRepository mockRepository = mock(MyRepository.class);

        doThrow(new RuntimeException("Error saving")).

        when(mockRepository).

        save(anyString());
        MyService service = new MyService(mockRepository);

        assertThrows(RuntimeException .class, () ->service.

        saveData("test data"));

```
