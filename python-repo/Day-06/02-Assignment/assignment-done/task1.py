## Nhiệm Vụ 1: Toán Tử Số Học

# 1. Tạo hai biến `a` và `b` với các giá trị số.
# 2. Tính tổng, hiệu, tích, và thương của `a` và `b`.
# 3. In kết quả.

import sys

def sum(num1, num2):
    add = num1 + num2
    return add

def subtract(num1, num2):
    sub = num1 - num2
    return sub

def multiply(num1, num2):
    mul = num1 * num2
    return mul

num1 = int(sys.argv[1])
opperator = sys.argv[2]
num2 = int(sys.argv[3])

if opperator == "add":
    output = sum(num1, num2)
    print(f'The result of addition is: {output}')
elif opperator == "sub":
    output = subtract(num1, num2)
    print(f'The result of subtraction is: {output}')
elif opperator == "mul":
    output = multiply(num1, num2)
    print(f'The result of multiplication is: {output}')