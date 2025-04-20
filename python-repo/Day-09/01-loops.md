# Loops in Python (for and while)

## Introduction

Vòng lặp là một khái niệm cơ bản trong lập trình, chúng cho phép bạn thực hiện các tác vụ lặp lại một cách hiệu quả. Trong Python, có hai loại vòng lặp chính: "for" và "while."

## For Loop

Vòng lặp "for" được sử dụng để lặp qua một chuỗi (như danh sách, tuple, chuỗi, hoặc range) và thực thi một tập hợp các câu lệnh cho mỗi phần tử trong chuỗi. Vòng lặp tiếp tục cho đến khi tất cả các phần tử trong chuỗi đã được xử lý.

**Syntax:**

```python
for variable in sequence:
    # Code to be executed for each item in the sequence
```

**Example:**

```python
fruits = ["apple", "banana", "cherry"]
for fruit in fruits:
    print(fruit)
```

**Output:**

```
apple
banana
cherry
```

Trong ví dụ này, vòng lặp lặp qua danh sách "fruits", và trong mỗi lần lặp, biến "fruit" nhận giá trị của phần tử hiện tại trong danh sách.

#### While Loop

Vòng lặp "while" tiếp tục thực thi một khối mã lệnh miễn là một điều kiện được chỉ định vẫn đúng. Nó thường được sử dụng khi bạn không biết trước vòng lặp cần chạy bao nhiêu lần.

**Syntax:**

```python
while condition:
    # Code to be executed as long as the condition is true
```

**Example:**

```python
count = 0
while count < 5:
    print(count)
    count += 1
```

**Output:**

```
0
1
2
3
4
```

Trong ví dụ này, vòng lặp "while" tiếp tục thực thi miễn là "count" nhỏ hơn 5. Biến "count" được tăng lên trong mỗi lần lặp.