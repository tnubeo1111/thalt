# Biểu Thức Chính Quy (Regex)

**1. Biểu Thức Chính Quy để Xử Lý Văn Bản:**

- Biểu thức chính quy (regex hoặc regexp) là một công cụ mạnh mẽ để khớp mẫu và xử lý văn bản.
- Mô-đun `re` trong Python được sử dụng để làm việc với biểu thức chính quy.
- Các ký tự đặc biệt phổ biến: `.` (bất kỳ ký tự nào), `*` (không hoặc nhiều lần), `+` (một hoặc nhiều lần), `?` (không hoặc một lần), `[]` (lớp ký tự), `|` (HOẶC), `^` (bắt đầu dòng), `$` (kết thúc dòng), v.v.
- Ví dụ sử dụng regex: khớp email, số điện thoại, hoặc trích xuất dữ liệu từ văn bản.
- Các hàm trong mô-đun `re` bao gồm `re.match()`, `re.search()`, `re.findall()`, và `re.sub()` để khớp mẫu và thay thế.