# Lists vs. Sets

## Lists

- **Bộ sưu tập có thứ tự:**
  - Danh sách là bộ sưu tập có thứ tự của các phần tử. Thứ tự thêm các phần tử được giữ nguyên.
  - Có thể truy cập phần tử bằng chỉ số (index).

  ```python
  my_list = [1, 2, 3, 4, 5]
  print(my_list[0])  # Output: 1
  ```

- **Có thể thay đổi:**
  - Danh sách có thể thay đổi, nghĩa là bạn có thể sửa đổi các phần tử sau khi tạo.

  ```python
  my_list[1] = 10
  ```

- **Cho phép phần tử trùng lặp:**
  - Danh sách có thể chứa các phần tử trùng lặp.

  ```python
  my_list = [1, 2, 2, 3, 4]
  ```

- **Use Cases:**
  - Sử dụng danh sách khi cần một bộ sưu tập có thứ tự và có khả năng sửa đổi phần tử.

## Sets

- **Bộ sưu tập không có thứ tự:**
  - Tập hợp là bộ sưu tập không có thứ tự của các phần tử duy nhất. Thứ tự thêm các phần tử không được giữ nguyên.
  - Không thể truy cập phần tử bằng chỉ số.

  ```python
  my_set = {1, 2, 3, 4, 5}
  ```

- **Có thể thay đổi:**
  - Tập hợp có thể thay đổi, nghĩa là bạn có thể thêm và xóa phần tử sau khi tạo.

  ```python
  my_set.add(6)
  ```

- **Không cho phép phần tử trùng lặp:**
  - Tập hợp không cho phép các phần tử trùng lặp. Nếu cố gắng thêm phần tử trùng, tập hợp sẽ không thay đổi và không báo lỗi.

  ```python
  my_set = {1, 2, 2, 3, 4}  # Results in {1, 2, 3, 4}
  ```

- **Trường hợp sử dụng:**
  - Sử dụng tập hợp khi cần một bộ sưu tập không có thứ tự của các phần tử duy nhất và muốn thực hiện các phép toán tập hợp như hợp, giao, hoặc hiệu.

### Các thao tác phổ biến:

- **Thêm phần tử:**
  - Danh sách sử dụng phương thức `append()` hoặc `insert()`.
  - Tập hợp sử dụng phương thức `add()`.

- **Xóa phần tử:**
  - Danh sách sử dụng  `remove()`, `pop()`, hoặc câu lệnh del.
  - Tập hợp sử dụng `remove()` hoặc `discard()`.

- **Kiểm tra thành viên:**
  - Danh sách sử dụng toán tử `in`.
  - Tập hợp cũng sử dụng toán tử `in`, hiệu quả hơn đối với tập hợp.

```python
# Lists
if 3 in my_list:
    print("3 is in the list")

# Sets
if 3 in my_set:
    print("3 is in the set")
```

### Choosing Between Lists and Sets

- **Use Lists When:**
  - Cần duy trì thứ tự của các phần tử.
  - Cho phép các phần tử trùng lặp.
  - Cần truy cập phần tử bằng chỉ số.

- **Use Sets When:**
  - Thứ tự không quan trọng.
  - Muốn đảm bảo các phần tử duy nhất.
  - Cần thực hiện các phép toán tập hợp như hợp, giao, hoặc hiệu.