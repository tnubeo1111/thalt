## Nhiệm Vụ 3: Toán Tử Logic

# 1. Tạo hai biến Boolean, `x` và `y`.
# 2. Sử dụng các toán tử logic (`and`, `or`, `not`) để thực hiện các phép toán logic trên `x` và `y`.
# 3. In kết quả.

x = input("Enter the first boolean value (True/False):")
y = input("Enter the second boolean value (True/False):")

if (x != "True" and x != "False") and (x != "true" and x != "false"):
    print("Invalid input for x. Please enter True or False.")
    exit()
elif (y != "True" and y != "False") and (y != "true" and y != "false"):
    print("Invalid input for y. Please enter True or False.")
    exit() 

def logical_and(x, y):
    return x and y

def logical_or(x, y):
    return x or y

def logical_not(x):
    return not x

print(f"Logical AND: {logical_and(x, y)}")
print(f"Logical OR: {logical_or(x, y)}")
print(f"Logical NOT x: {logical_not(x)}")