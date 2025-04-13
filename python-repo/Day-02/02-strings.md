# Chuỗi (Strings)

**1. Kiểu Dữ Liệu Chuỗi trong Python:**

- Trong Python, chuỗi là một dãy ký tự, được đặt trong dấu nháy đơn (' '), nháy kép (" "), hoặc dấu nháy ba (''' ''' hoặc """ """).
- Chuỗi là bất biến (immutable), nghĩa là bạn không thể thay đổi các ký tự trong một chuỗi trực tiếp. Thay vào đó, bạn tạo ra chuỗi mới.
- Bạn có thể truy cập các ký tự riêng lẻ trong chuỗi bằng cách sử dụng chỉ số (indexing), ví dụ: `my_string[0]` sẽ trả về ký tự đầu tiên.
- Chuỗi hỗ trợ nhiều phương thức tích hợp sẵn, như `len()`, `upper()`, `lower()`, `strip()`, `replace()`, và nhiều phương thức khác để thao tác.

**2. Thao Tác và Định Dạng Chuỗi:**

- **Nối chuỗi (Concatenation):** Bạn có thể kết hợp các chuỗi bằng toán tử `+`.
- **Trích xuất chuỗi con (Substrings):** Sử dụng slicing để lấy một phần của chuỗi, ví dụ: `my_string[2:5]` sẽ lấy các ký tự từ vị trí 2 đến vị trí 4.
- **Nội suy chuỗi (String interpolation):** Python hỗ trợ nhiều cách để định dạng chuỗi, bao gồm f-strings (`f"...{variable}..."`), định dạng kiểu `%` (`"%s %d" % ("string", 42)`), và phương thức `str.format()`.
- **Ký tự thoát (Escape sequences):** Các ký tự đặc biệt như xuống dòng (`\n`), tab (`\t`), và các ký tự khác được biểu diễn bằng ký tự thoát.
- **Phương thức chuỗi (String methods):** Python cung cấp nhiều phương thức tích hợp để thao tác chuỗi, như `split()`, `join()`, và `startswith()`.