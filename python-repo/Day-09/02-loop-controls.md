# Loop Control Statements (break and continue)

## Introduction

Các câu lệnh điều khiển vòng lặp được sử dụng để thay đổi hành vi của vòng lặp, cung cấp khả năng kiểm soát và linh hoạt hơn trong quá trình lặp. Trong Python, hai câu lệnh điều khiển vòng lặp chính là "break" và "continue."

## `break` Statement

Câu lệnh "break" được sử dụng để thoát khỏi vòng lặp trước khi nó hoàn tất. Nó có thể được áp dụng cho cả vòng lặp "for" và "while", cho phép bạn dừng vòng lặp khi một điều kiện cụ thể được đáp ứng.

**Example:**

```python
numbers = [1, 2, 3, 4, 5]
for number in numbers:
    if number == 3:
        break
    print(number)
```

**Output:**

```
1
2
```

Trong ví dụ này, vòng lặp dừng lại khi gặp số 3.

## `continue` Statement

Câu lệnh "continue" được sử dụng để bỏ qua lần lặp hiện tại của vòng lặp và chuyển sang lần lặp tiếp theo. Nó có thể được sử dụng trong cả vòng lặp "for" và "while", cho phép bạn bỏ qua một số lần lặp dựa trên một điều kiện.

**Example:**

```python
numbers = [1, 2, 3, 4, 5]
for number in numbers:
    if number == 3:
        continue
    print(number)
```

**Output:**

```
1
2
4
5
```

Trong ví dụ này, vòng lặp bỏ qua lần lặp khi số là 3 và tiếp tục với lần lặp tiếp theo.

## Practice Exercise - Automating Log File Analysis

#### Introduction

Trong bài tập thực hành này, chúng ta sử dụng vòng lặp "for" để tự động phân tích một tệp nhật ký và xác định các dòng chứa từ "error". Điều này thể hiện cách các vòng lặp có thể được sử dụng để xử lý dữ liệu và trích xuất thông tin liên quan một cách hiệu quả.

**Example:**

```python
log_file = [
   "INFO: Operation successful",
   "ERROR: File not found",
   "DEBUG: Connection established",
   "ERROR: Database connection failed",
]

for line in log_file:
   if "ERROR" in line:
       print(line)
```

**Output:**

```
ERROR: File not found
ERROR: Database connection failed
```

Trong bài tập này, vòng lặp lặp qua danh sách "log_file" và in ra các dòng chứa từ "ERROR".