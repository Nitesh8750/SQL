"""
# 1. Find the sum of two numbers

def sum(a,b):
    c = a +b
    return c

d = sum(4,5)
print(d)
print("*" * 50)

# ***********************************************************************************************

# 2. Determine if a number is even or odd
def check_even_odd(n):
    
    if n % 2 == 0:
      print("Even")
    elif n % 2 != 0:
      print("ODD")
    else:
      print("Provide correct number")
n = 7  
check_even_odd(n)
print("*" * 50)

# ***********************************************************************************************


# 3. Find the largest of three numbers
def largest(a,b,c):
    if a > b and a>c:
        print(f"{a} is grestest number")
    elif b>a and b>c:
        print(f"{b} is greatest number")
    else :
        print(f"{c} is greatest number")

largest(24,45,20)
largest(2,5,20)
largest(24,5,2)
print("*" * 50)

# ***********************************************************************************************



# 4. Reverse a string
def reverse(name):
    rev = ""
    for i in name:
        rev = i + rev
    print(rev)
reverse("Nitesh")

# OR
 
# using function
def reverse(name):
    rev = "".join(reversed(name)) 
    print(rev)
reverse("Nitesh")

name = "Hello"
rev = "".join(reversed(name))
print(rev)

# you can use reversed(). However, this returns an "iterator," 
# so you must use .join() to turn it back into a string.

#OR

# Using slicing
def reverse(name):
    rev = name[::-1]
    print(rev)

name = "Hello"
reverse(name)
print("*" * 50)

# ***********************************************************************************************




# 5. Check if a string is a palindrome
def palindrome(name):
    string = ""
    for i in name:
        string = i + string
    print(string)
    if name == string:
        print("It is palindrome")
    else:
        print("It is not palindrome") 
palindrome("madam")
print("*" * 50)

# ***********************************************************************************************


# 6. Calculate the factorial of a number
def factorial(number):
    mul = 1
    if number == 0:
        print("The factoral is 1")
    elif number >= 1:
        for i in range(1,number+1):
            mul = mul * i
        print(mul)
number = int(input("Enter number:"))
factorial(number)
print("*" * 50)

# ***********************************************************************************************




# 7. Find the sum of all numbers in a list
l1 = [1, 2, 3, 4, 5]
sum = 0
for i in l1:
    sum = sum + i
print(sum)

#OR

def sum():
    l1 = [1, 2, 3, 4, 5]
    sum = 0
    for i in l1:
        sum = sum + i
    return sum
print(sum())

print("*" * 50)

# ***********************************************************************************************


# 8. Count the number of vowels in a string

vowels = ['a','e','i','o','u']
name = 'education'
count = 0
for i in vowels:
    if i in name:
        count = count + 1
print(count)

# OR

def no_of_vowels():
    vowels = ['a','e','i','o','u','A','E','I','O','U']
    name = 'Education'
    count = 0
    for i in vowels:
        if i in name:
            count = count + 1
    return count
print(no_of_vowels())
print("*" * 50)

# ***********************************************************************************************



# 9. Generate the Fibonacci sequence up to n terms    
def fibonacci(n):
    a,b = 0,1
    result = []
    for i in range(n):
        
        result.append(a)
        a,b  = b, a+b
    return result
print(fibonacci(5))



def fibonacci_pyramid(rows):
    # 1. Calculate total numbers needed for the pyramid
    # Formula for total items in a pyramid: (n * (n + 1)) / 2
    total_numbers = (rows * (rows + 1)) // 2
    
    # 2. Generate the Fibonacci sequence
    a, b = 0, 1
    fib_list = []
    for _ in range(total_numbers):
        fib_list.append(a)
        a, b = b, a + b
    
    # 3. Print the pyramid
    current_index = 0
    for i in range(1, rows + 1):
        # Get the slice of numbers for the current row
        row_items = fib_list[current_index : current_index + i]
        current_index += i
        
        # Convert numbers to strings and join with spaces
        row_string = " ".join(map(str, row_items))
        
        # Print centered (adjust width 30 to be larger if using many rows)
        print(row_string.center(40))

# Change this number to see a bigger or smaller pyramid
fibonacci_pyramid(5)
print("*" * 50)

# ***********************************************************************************************


# 10. Find the second largest number in a list

# first i will sorrt the list by using Bubble sort method not (sort() method)
def second_largest_number():
    l2 = [4, 3, 1, 2]
    n = len(l2)
    # We use range(n) to get indices: 0, 1, 2, 3
    for i in range(n):
        for j in range(0,n-i-1):
            if l2[j] > l2[j+1]:
                # Swap the elements at positions j and j+1
                l2[j], l2[j+1] = l2[j+1], l2[j]
    return l2

# When i = 0 (First Pass):
# The loop runs until j reaches 4 - 0 - 1 = 3.
# It compares everything. By the end, 4 is at the last spot: [3, 2, 1, 4].
# The last item is now "Locked."

# When i = 1 (Second Pass):
# The loop runs until j reaches 4 - 1 - 1 = 2.
# We don't need to check the last spot because we already know 4 is the biggest. We only sort [3, 2, 1].
# By the end, 3 is locked: [2, 1, 3, 4].

l3 = second_largest_number()
print(l3)

# after sorting the list finding second largest number
second_largest = l3[-2]
print(second_largest)


# OR 

def second_largest_number():
    l2 = [4, 3, 1, 2]
    l2.sort()
    return l2
c = second_largest_number()
print(c)
print(c[-2])
print("*" * 50)

# ***********************************************************************************************

# 11. Find the GCD (Greatest Common Divisor) of two numbers
import math

def gcd():
    a,b = 54, 24
    c= math.gcd(a, b)
    print(c)

gcd()

print("*" * 50)

# ***********************************************************************************************


# 12. Find the LCM (Least Common Multiple) of two numbers
import math

def lcm():
    a = 54
    b = 24
    c = math.lcm(a,b)
    print(c)
lcm()

print("*" * 50)

# ***********************************************************************************************

# 13. Check if a number is prime
def prime_number(n):
    if n > 1:
        for i in range(2,n):
            if n % i == 0:
                print(f"{n} is not a prime number")
                break
        else :
            print("It is a prime number")
prime_number(14)

print("*" * 50)

# ***********************************************************************************************

# 14. Find the length of the longest word in a sentence
def longest(a):
    b = a.split()
    print(b)
    c = max(b, key=len)
    return c

print(longest("Python is amazing"))

print("*" * 50)

# ***********************************************************************************************


# 15. Convert a list of strings to uppercase
def uppcase():
    a = ["a","b","c","d"]
    for i in a:
        b = i.capitalize()
        print(b)
uppcase()

print("*" * 50)

# ***********************************************************************************************


# 16. Remove duplicates from a list
def duplicates():
    a = [1,2,3,4,1,2,6,5,3]
    b = list(set(a))
    return b
print(duplicates())

print("*" * 50)

# ***********************************************************************************************


# 17. Sort a list of numbers in ascending order
def asc_sort():
    a = [5, 3, 8, 1, 2]
    n = len(a)
    for i in range(n):
        for j in range(0, n-i-1):
            if a[j] > a[j+1]:
                a[j], a[j+1] = a[j+1], a[j]
    return a
print(asc_sort())

# OR

c = [5, 3, 8, 1, 2]
c.sort()
print(c)

print("*" * 50)

# ***********************************************************************************************


# 18. Find the common elements in two lists
def common_list():
    l1 = [1,2,3,4,5]
    l2 = [3,4,5,6,7]
    common = []
    for i in l1:
        for j in l2:
            if i == j:
                common.append(i)
    return common
print(common_list())

print("*" * 50)

# ***********************************************************************************************


# 19. Check if two strings are anagrams
# Two strings are anagrams if they contain the exact same characters with the exact same frequency, 
# but in a different order (for example, "listen" and "silent").

def anagrams(s1, s2):
    s1 = s1.replace(" ", "").lower()
    s2 = s2.replace(" ", "").lower()
    
    if len(s1) != len(s2):
        print("Letters are not anagrams")
    elif sorted(s1) == sorted(s2):
        print("Both letter are anagrams")
    else:
        print("Letters are not anagrams")

s1 = input("Enter first word:")
s2 = input("Enter second word:")
anagrams(s1 , s2)

print("*" * 50)

# ***********************************************************************************************
"""


# 20. Find the intersection of two sets
def find_intersection(a,b):
    return set(a).intersection(set(b))
    # return list(set(a).intersection(set(b)))

a = [1,2,3]
b = [3,4,5]
print(find_intersection(a,b))