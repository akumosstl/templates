# Javascript

# 1 - Question 
[What is closure?]

# 1 - Answer
A closure is a feature in JavaScript where an inner function has access to its outer function's variables, even after the outer function has finished executing. Closures allow for data encapsulation and can be used to create private variables.

Question: What is hoisting?
Answer: Javascript has two fases the compilation and execution, when you define a variable or function , on the execution phase those will be hoisted on the top of the scope to the global window object, that’s why if you access before it’s declaration it will come as undefined for var . let and const gets hoisted in a different memory location of the window object the temporary dead zone which is the moment between the compilation and execution phase.and it will come as uncaught reference error cannot access variable before initializaiton.
Question: Difference Among Var, let and const variable declarations
Answer: Var has a function while let and const has a block scope. Const variable cannot be redefined and it needs a initial value.
