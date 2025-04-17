## Tổng kết bài học Python: Đối số dòng lệnh và Biến môi trường

### Mục tiêu
- Hiểu và áp dụng cách sử dụng đối số dòng lệnh (`sys.argv`) và biến môi trường (`os.getenv`) trong Python.

---

### Từ khóa và Khái niệm chính

#### 1. Đối số dòng lệnh (`sys.argv`)
- **Thư viện:** `sys`
- **Chức năng:** Lấy các đối số truyền vào chương trình Python từ dòng lệnh.
- **Cú pháp:**
    ```python
    import sys
    sys.argv  # Danh sách các đối số, sys.argv[0] là tên file, sys.argv[1:] là các đối số người dùng truyền vào.
    ```
- **Ví dụ:**
    ```python
    num1 = int(sys.argv[1])      # Lấy đối số thứ nhất và ép kiểu sang int
    operator = sys.argv[2]       # Lấy đối số thứ hai (toán tử)
    num2 = int(sys.argv[3])      # Lấy đối số thứ ba và ép kiểu sang int
    ```
- **Ứng dụng:** Xử lý tham số đầu vào linh hoạt, ví dụ: chọn phép toán (cộng, trừ, nhân) và các số từ dòng lệnh.
- **Lưu ý:**
    - Kiểm tra số lượng và kiểu dữ liệu của đối số để tránh lỗi.
    - Sử dụng `int()` hoặc `float()` để chuyển đổi đối số dạng chuỗi thành số.

#### 2. Biến môi trường (`os.getenv`)
- **Thư viện:** `os`
- **Chức năng:** Truy xuất giá trị của các biến môi trường được thiết lập trong hệ thống.
- **Cú pháp:**
    ```python
    import os
    os.getenv("TÊN_BIẾN")  # Trả về giá trị của biến môi trường, hoặc None nếu không tồn tại.
    ```
- **Ví dụ:**
    ```python
    print(os.getenv("CTX_CLUSTER1"))  # In giá trị của biến môi trường CTX_CLUSTER1
    ```
- **Ứng dụng:** Lấy các giá trị cấu hình hệ thống, ví dụ: tên cụm, địa chỉ, hoặc thông tin bí mật (secrets).
- **Lưu ý:**
    - Kiểm tra giá trị trả về để xử lý trường hợp biến không tồn tại.
    - Biến môi trường thường được thiết lập trước khi chạy chương trình (qua terminal hoặc file cấu hình).

---

### Bài học rút ra
- **Đối số dòng lệnh:** Phù hợp cho các tham số thay đổi mỗi lần chạy chương trình, như đầu vào của phép tính.
- **Biến môi trường:** Tốt cho việc quản lý các giá trị cấu hình cố định hoặc nhạy cảm (như thông tin kết nối cụm hoặc bí mật SSL).
- **Kết hợp:** Có thể dùng cả hai để xây dựng chương trình linh hoạt, ví dụ: lấy cấu hình từ biến môi trường và tham số tính toán từ dòng lệnh.

---

### Bài tập đã thực hiện

#### 1. Tính toán với đối số dòng lệnh
- Nhận 3 đối số: số thứ nhất, toán tử (`add`, `sub`, hoặc khác), số thứ hai.
- Thực hiện phép cộng, trừ, hoặc nhân dựa trên toán tử.
- In kết quả ra màn hình.

#### 2. In biến môi trường
- Truy xuất và in giá trị của các biến môi trường liên quan đến cấu hình cụm và thông tin bí mật.
- Sử dụng `os.getenv` để lấy giá trị.

---

### Tài liệu tham khảo
- [Python sys module](https://docs.python.org/3/library/sys.html)
- [Python os module](https://docs.python.org/3/library/os.html)

