# Reverse a string

## answer-1

```java
public class StringReversal {
    public static String reverseString(String str) {
        StringBuilder reversed = new StringBuilder();
        for (int i = str.length() - 1; i >= 0; i--) {
            reversed.append(str.charAt(i));
        }
        return reversed.toString();
    }

    public static void main(String[] args) {
        String original = "hello";
        String reversed = reverseString(original);
        System.out.println("Original: " + original); // Output: Original: hello
        System.out.println("Reversed: " + reversed); // Output: Reversed: olleh
    }
}

```

## answer-2

```java
public class StringPrograms {

    public static void main(String[] args) {
        String str = "123";

        System.out.println(reverse(str));
    }

    public static String reverse(String in) {
        if (in == null)
            throw new IllegalArgumentException("Null is not valid input");

        StringBuilder out = new StringBuilder();

        char[] chars = in.toCharArray();

        for (int i = chars.length - 1; i >= 0; i--)
            out.append(chars[i]);

        return out.toString();
    }

}
```

# How do you swap two numbers without using a third variable in Java?

```js
b = b + a; // now b is sum of both the numbers
a = b - a; // b - a = (b + a) - a = b (a is swapped)
b = b - a; // (b + a) - b = a (b is swapped)

```

## - answer-1

```java
public class SwapNumbers {

    public static void main(String[] args) {
        int a = 10;
        int b = 20;

        System.out.println("a is " + a + " and b is " + b);

        a = a + b;
        b = a - b;
        a = a - b;

        System.out.println("After swapping, a is " + a + " and b is " + b);
    }

}
```

# Write a Java program to check if a vowel is present in a string

```java
public class StringContainsVowels {

    public static void main(String[] args) {
        System.out.println(stringContainsVowels("Hello")); // true
        System.out.println(stringContainsVowels("TV")); // false
    }

    public static boolean stringContainsVowels(String input) {
        return input.toLowerCase().matches(".*[aeiou].*");
    }

}

```

# Write a Java program to check if the given number is a prime number

```java
public class PrimeNumberCheck {

    public static void main(String[] args) {
        System.out.println(isPrime(19)); // true
        System.out.println(isPrime(49)); // false
    }

    public static boolean isPrime(int n) {
        if (n == 0 || n == 1) {
            return false;
        }
        if (n == 2) {
            return true;
        }
        for (int i = 2; i <= n / 2; i++) {
            if (n % i == 0) {
                return false;
            }
        }

        return true;
    }

}
```

# Write a Java program to print a Fibonacci sequence using recursion

```java
public static boolean onlyOddNumbers(List<Integer> list) {
    for (int i : list) {
        if (i % 2 == 0)
            return false;
    }

    return true;
}
```

# How do you check whether a string is a palindrome in Java?

```java
boolean checkPalindromeString(String input) {
    boolean result = true;
    int length = input.length();

    for (int i = 0; i < length / 2; i++) {
        if (input.charAt(i) != input.charAt(length - i - 1)) {
            result = false;
            break;
        }
    }

    return result;
}
```

# How do you remove spaces from a string in Java?

```java
String removeWhiteSpaces(String input) {
    StringBuilder output = new StringBuilder();

    char[] charArray = input.toCharArray();

    for (char c : charArray) {
        if (!Character.isWhitespace(c))
            output.append(c);
    }

    return output.toString();
}
```

# How do you sort an array in Java?

```java
int[] array = {1, 2, 3, -1, -2, 4};

Arrays.

sort(array);

System.out.

println(Arrays.toString(array));

```

# How can you find the factorial of an integer in Java?

F(n) = F(1)*F(2)...F(n-1)*F(n)

```java
public static long factorial(long n) {
    if (n == 1)
        return 1;
    else
        return (n * factorial(n - 1));
}
```

# How do you reverse a linked list in Java?

```java
LinkedList<Integer> ll = new LinkedList<>();

ll.

add(1);
ll.

add(2);
ll.

add(3);

System.out.

println(ll);

LinkedList<Integer> ll1 = new LinkedList<>();

ll.

descendingIterator().

forEachRemaining(ll1::add);

System.out.

println(ll1);
```
