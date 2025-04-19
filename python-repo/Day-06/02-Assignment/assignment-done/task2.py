## Nhiệm Vụ 2: Toán Tử So Sánh

# 1. So sánh giá trị của `a` và `b` bằng các toán tử so sánh: `<`, `>`, `<=`, `>=`, `==`, và `!=`.
# 2. In kết quả của từng phép so sánh.

import sys

def less_than(num1, num2):
    less = num1 < num2
    return less

def greater_than(num1, num2):
    greater = num1 > num2
    return greater

def less_than_or_equal(num1, num2):
    less_equal = num1 <= num2
    return less_equal

def greater_than_or_equal(num1, num2):
    greater_equal = num1 >= num2
    return greater_equal

def equal(num1, num2):
    equal = num1 == num2
    return equal

def not_equal(num1, num2):
    notEqual = num1 != num2
    return notEqual

num1 = int(sys.argv[1])
comparetor = sys.argv[2]
num2 = int(sys.argv[3])

if comparetor == "less":
    output = less_than(num1, num2)
    print(f"The result of less than comparison is: {num1} < {num2} is {output}")
elif comparetor == 'greater':
    output = greater_than(num1, num2)
    print(f"The result of greater than comparison is: {num1} > {num2} is {output}")
elif comparetor == "less_equal":
    output = less_than_or_equal(num1, num2)
    print(f"The result of less than or equal comparison is: {num1} <= {num2} is {output}")
elif comparetor == "greater_equal":
    output = greater_than_or_equal(num1, num2)
    print(f"The result of greater than or equal comparison is: {num1} >= {num2} is {output}")
elif comparetor == "equal":
    output = equal(num1, num2)
    print(f"The result of equal comparison is: {num1} = {num2} is {output}")
elif comparetor == "not_equal":
    output = not_equal(num1, num2)
    print(f"The result of not equal comparison is: {num1} != {num2}  is {output}")

else:
    print("Invalid operator. Please use <, >, <=, >=, ==, or !=")