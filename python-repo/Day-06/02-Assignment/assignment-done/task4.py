## Nhiệm Vụ 4: Toán Tử Gán

# 1. Tạo một biến `total` và khởi tạo giá trị của nó là 10.
# 2. Sử dụng các toán tử gán (`+=`, `-=`, `*=`, `/=`) để cập nhật giá trị của `total`.
# 3. In giá trị cuối cùng của `total`.

import sys

def add_assign(total, number):
    total += number
    return total

def subtract_assign(total, number):
    total -= number
    return total

def multiply_assign(total, number):
    total *= number
    return total

def divide_assign(total, number):
    total /= number
    return total

total = float(sys.argv[1])
opperator = sys.argv[2]
number = float(sys.argv[3])

if opperator == "add":
    output = add_assign(total, number)
    print(f'The result of addition assignment is: {output}')
elif opperator == "sub":
    output = subtract_assign(total, number)
    print(f'The result of subtraction assignment is: {output}')
elif opperator == "mul":
    output = multiply_assign(total, number)
    print(f'The result of multiplication assignment is: {output}')
elif opperator == "div":
    output = divide_assign(total, number)
    print(f'The result of division assignment is: {output}')
else:
    print("Invalid operator. Please use add, sub, mul, or div.")