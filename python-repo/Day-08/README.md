# List và Tuple trong Python

## 1. List trong Python

### Khái niệm:
- **List** là một kiểu dữ liệu trong Python, dùng để lưu trữ một tập hợp các phần tử (các giá trị hoặc đối tượng) theo thứ tự.
- List có thể chứa bất kỳ loại dữ liệu nào: số, chuỗi, hoặc thậm chí các list khác.
- List là **mutable** (có thể thay đổi), nghĩa là bạn có thể thêm, xóa hoặc sửa các phần tử sau khi tạo.

### Cú pháp:
```python
my_list = [1, 2, 3, "hello", 4.5]
```

### Đặc điểm:
 - Truy cập phần tử: Sử dụng chỉ số (index), bắt đầu từ 0.
```
print(my_list[0])  # Kết quả: 1
```
 - Thay đổi phần tử:
```
my_list[1] = "world"
print(my_list)  # Kết quả: [1, "world", 3, "hello", 4.5]
```
### Các phương thức phổ biến:
 - **append(x)**: Thêm x vào cuối list.
 - **remove(x)**: Xóa phần tử x đầu tiên trong list.
 - **pop(i)**: Xóa và trả về phần tử tại chỉ số i (mặc định là phần tử cuối).
 - **sort()**: Sắp xếp list.
 - **len()**: Trả về độ dài của list.

### Ví dụ:
```python
fruits = ["apple", "banana", "orange"]
fruits.append("grape")
print(fruits)  # Kết quả: ["apple", "banana", "orange", "grape"]

fruits.remove("banana")
print(fruits)  # Kết quả: ["apple", "orange", "grape"]
```
## 2. Tuple trong Python
### Khái niệm:
 - Tuple cũng là một kiểu dữ liệu dùng để lưu trữ tập hợp các phần tử theo thứ tự, tương tự list.
 - Khác với list, tuple là immutable (không thể thay đổi). Sau khi tạo, bạn không thể thêm, xóa hoặc sửa phần tử.

### Cú pháp:
```python
my_tuple = (1, 2, 3, "hello", 4.5)
```
### Đặc điểm:
 - Truy cập phần tử: Cũng sử dụng chỉ số, giống list.
```
print(my_tuple[0])  # Kết quả: 1
```
- Không thể thay đổi:
```markdown
my_tuple[1] = "world"  # Lỗi: TypeError
```
### Ưu điểm:
 - Nhanh hơn list (do tính bất biến).
 - Thường dùng để lưu trữ dữ liệu cố định, như tọa độ (x, y) hoặc thông tin không cần thay đổi.

### Phương thức phổ biến:
 - **count(x)**: Đếm số lần xuất hiện của x.
 - **index(x)**: Trả về chỉ số đầu tiên của x.
 - **len()**: Trả về độ dài của tuple.

### Ví dụ:
```python
colors = ("red", "blue", "green")
print(colors[1])  # Kết quả: blue
print(colors.count("red"))  # Kết quả: 1
```
## 3. So sánh List và Tuple
| Tiêu chí      | List                | Tuple                       |
|---------------|---------------------|-----------------------------|
| Cú pháp       | `[1, 2, 3]`         | `(1, 2, 3)`                 |
| Mutable       | Có (có thể thay đổi) | Không (bất biến)            |
| Hiệu suất     | Chậm hơn tuple      | Nhanh hơn list              |
| Ứng dụng      | Dữ liệu cần thay đổi thường xuyên | Dữ liệu cố định, bảo vệ dữ liệu |
| Phương thức   | Nhiều (append, remove,...) | Ít (count, index)           |

## 4. Một số lưu ý khi làm việc với List và Tuple
#### List comprehension (dành cho list):
Cách viết ngắn gọn để tạo list.
```markdown
squares = [x**2 for x in range(5)]  # Kết quả: [0, 1, 4, 9, 16]
```
#### Unpacking:
Áp dụng cho cả list và tuple.
```markdown
a, b, c = (1, 2, 3)
print(a, b, c)  # Kết quả: 1 2 3
```
#### Slicing:
Cắt lát list hoặc tuple.
```markdown
my_list = [0, 1, 2, 3, 4]
print(my_list[1:4])  # Kết quả: [1, 2, 3]
```

