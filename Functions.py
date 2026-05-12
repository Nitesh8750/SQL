#Functions
"""

Functions :- it is defind as reusable machines.
A function is defined using the def keyword, followed by the function name, parentheses (), 
and a colon :. The code block inside must be indented.

def function_name(parameters):
    # Docstring (optional description)
    # This function does XYZ.
    
    # Function Body (the logic)
    result = parameters * 2
    
    # Return Statement
    return result
    
    
Examples :-

def add(a,b):
    sum = a + b
    print(sum)
    
add(2,3)

def adding(c,d):
    return c+d

sum = adding(3,4)
print(sum)


Key Components:
Name: Should be descriptive (e.g., calculate_tax instead of func1).
Parameters: Variables that act as placeholders for the data you pass in.
Return: The return keyword exits the function and sends a value back to the caller. If no return is specified, it returns None by default.

# Differe between print and return 
# Return Statement                                         Print Statement
# It is used to exit a function and return a value         It is used to display output to the console
# It returns a value that can be assigned to a variable    It displays output to the console but does
# or used in any expression                                not return the value

# ************************************************************************************************

# Some Question of basic functions

# 1 Wap to define a function to find square of user input number
def square(a):
    return a**2

a = int(input("Enter number:"))
b = square(a)
print(b)


# 2. WAP to define a function to print name of a student
def name(a):
    return a

a = input("Enter name:")
b = name(a)
print(b)


# 3. Wap to append the value in a list
def change_list(list1):
    list1.append(20)
    list1.append(30)
    return list1

list1 = [10,30,40,50]
b= change_list(list1)
print(b)


# 4. 
def check_age(name, age):
    if age <= 18:
        print(f"Hey {name} can't have this beer")
    else:
        print(f"Hey {name} you get beer.")
    
name = input("Enter name:")
age = int(input("Enter age:"))

check_age(name,age)
check_age(name = "Nitesh",age = 18)
check_age(age = 18, name = "nitesdh")



#************************************************************************************************

# Types of Function based on parameters
Argumental functions" (more commonly called functions with arguments) 
are functions designed to accept inputs. These inputs, called parameters, 
allow the function to be flexible and perform different results based on what you feed it. 

1. Positional Arguments

The most common type. The order in which you pass the values matters. 
The first value goes to the first parameter, the second to the second, and so on.

def describe_pet(animal, name):
    print(f"I have a {animal} named {name}.")

describe_pet("dog", "Rex") # Correct: "I have a dog named Rex."
describe_pet("Rex", "dog") # Confusion: "I have a Rex named dog."


2. Keyword Arguments
You explicitly state which parameter the value belongs to. 
This makes order irrelevant and improves readability.

def describe_pet(animal, name):
    print(f"I have a {animal} named {name}.")

describe_pet(name="Rex", animal="dog")   
# Result is still: "I have a dog named Rex."
# if we chnage the position of values against the parameters at the time of function calling


3. Default Arguments
You can assign a default value to a parameter. 
If the user doesn't provide an argument for it, the function uses the default.

def greet(name, message="Welcome"):
    print(f"{message}, {name}!")

greet("Alice")           # Output: Welcome, Alice!
greet("Bob", "Goodbye")  # Output: Goodbye, Bob!

# if we assign the default parameter to left argument(name) then i have to assign default parameter
to right argument(message) also. like def greet(name = "nitesh", message="Welcome"):
# and if we assign the values to the default arguments again at the time function calling then it 
will override the default parameters


4. Arbitrary Arguments (*args and kwargs)
Sometimes you don't know how many arguments will be passed.

*args: Collects extra positional arguments into a tuple.
**kwargs: Collects extra keyword arguments into a dictionary.

example :-

def make_pizza(size, *toppings):
    print(f"Making a {size} pizza with: {toppings}")

make_pizza("Large", "Pepperoni", "Mushrooms", "Olives")
# toppings becomes ('Pepperoni', 'Mushrooms', 'Olives')


def get_sum(*number):
    sum = 0
    for i in number:
        sum = sum + i
    return sum

sum  = get_sum(23,45,4576,2324,78)
print(sum)



def infor(name, **extra_info):
    print(f"Name : {name}")
    for i,j in extra_info.items():
        print(i,j)
    
infor("Nitesh", age = 25, city = "Faridabad", pincode = 121003)


def build_profile(name, **additional_info):
    print(f"User: {name}")
    
    # additional_info is a dictionary containing all extra keyword arguments
    print(f"Data type of additional_info: {type(additional_info)}")
    
    for key, value in additional_info.items():
        print(f"- {key.capitalize()}: {value}")

# Calling the function with different amounts of extra info
build_profile("Alice", age=28, city="New York", occupation="Engineer")

print("-" * 20)

build_profile("Bob", hobby="Photography", status="Active")



# ************************************************************************************************
# Questions

# 1. Question: WAP function to calculate the factorial of a number (a non-negative integer). The 
# function accepts the number as an argument

def factorial(n):
    mul = 1
    if n == 0:
        mul= 1
    else :
        for i in range(1, n+1):
            mul  =  mul * i
    return mul
n = int(input("Enter any number:"))
fact = factorial(n)
print(fact)
"""

# Question: Write a Python function that takes a number as a parameter and checks whether the number is 
# prime or not

def prime(n):
    if n > 1:
        for i in range(2, n):
            if n % i == 0 :
                print("It is not a prime mumber:")
                break
        else :
            print("It is a prime number")

n = int(input("Enter number"))
prime(n)