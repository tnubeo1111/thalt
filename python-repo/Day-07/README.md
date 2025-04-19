# Conditional Statements in Python

Các câu lệnh điều kiện là một phần cơ bản của lập trình, cho phép bạn đưa ra quyết định và thực thi các khối mã khác nhau dựa trên các điều kiện nhất định. Trong Python, bạn có thể sử dụng `if`, `elif` (viết tắt của "else if"), và `else` để tạo các câu lệnh điều kiện.

## `if` Statement

Câu lệnh `if` được sử dụng để thực thi một khối mã nếu một điều kiện được chỉ định là `True`. Nếu điều kiện là `False`, khối mã sẽ bị bỏ qua.

```python
if condition:
    # Code to execute if the condition is True
```

- Ví dụ:

```python
x = 10
if x > 5:
    print("x is greater than 5")
```

## `elif` Statement

Câu lệnh `elif` cho phép bạn kiểm tra các điều kiện bổ sung nếu các điều kiện trước đó trong `if` hoặc `elif` là `False`. Bạn có thể có nhiều câu lệnh `elif` sau câu lệnh `if` ban đầu.

```python
if condition1:
    # Code to execute if condition1 is True
elif condition2:
    # Code to execute if condition2 is True
elif condition3:
    # Code to execute if condition3 is True
# ...
else:
    # Code to execute if none of the conditions are True
```

- Ví dụ:

```python
x = 10
if x > 15:
    print("x is greater than 15")
elif x > 5:
    print("x is greater than 5 but not greater than 15")
else:
    print("x is not greater than 5")
```

## `else` Statement

Câu lệnh `else` được sử dụng để chỉ định một khối mã sẽ được thực thi khi không có điều kiện nào trước đó (trong các câu lệnh `if` và `elif`) là `True`.

```python
if condition:
    # Code to execute if the condition is True
else:
    # Code to execute if the condition is False
```

- Ví dụ:

```python
x = 3
if x > 5:
    print("x is greater than 5")
else:
    print("x is not greater than 5")
```