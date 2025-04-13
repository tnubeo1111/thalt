import re

text = "The quick brown fox"
pattern = r"brown"

search = re.search(pattern, text)
if search:
    print("Pattern found:", search.group())
else:
    print("Pattern not found")

# Đoạn mã trên tìm kiếm một mẫu trong chuỗi và in ra kết quả.
# Ghi chú: Đoạn mã trên sử dụng thư viện `re` (regular expression) để tìm kiếm một mẫu (pattern) trong chuỗi.
# - `re.search(pattern, text)` tìm kiếm mẫu `pattern` trong chuỗi `text`.
# - Nếu tìm thấy, nó trả về một đối tượng match, và bạn có thể sử dụng `.group()` để lấy giá trị khớp.
# - Nếu không tìm thấy, nó trả về `None`.
