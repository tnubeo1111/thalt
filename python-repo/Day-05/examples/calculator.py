import sys

def addition(num1, num2):
    add = num1 + num2
    return add

def subtraction(num1, num2):
    sub = num1 - num2
    return sub

def multiplication(num1, num2):
    mul = num1 * num2
    return mul



num1 = int(sys.argv[1])
operator = sys.argv[2]
num2 = int(sys.argv[3])

if operator == "add":
    output = addition(num1, num2)
    print(f"The result of addition is: {output}")
elif operator == "sub":
    output = subtraction(num1, num2)
    print(f"The result of subtraction is: {output}")
else:
    output = multiplication(num1, num2)
    print(f"The result of multiplication is: {output}")