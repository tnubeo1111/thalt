import re

text = "The quick brown fox jumps over the lazy brown dog"
pattern = r"brown"

replacement = "red"

new_text = re.sub(pattern, replacement, text)
print("Modified text:", new_text)

# Đoạn mã trên thay thế tất cả các chuỗi "brown" trong chuỗi gốc bằng "red".
# Ghi chú:
# 1. Đoạn mã này sử dụng module `re` (regular expression) để thay thế các chuỗi con trong một chuỗi lớn hơn.
# 2. Biến `text` chứa chuỗi gốc.
# 3. Biến `pattern` chứa biểu thức chính quy (regex) để tìm kiếm chuỗi "brown".
# 4. Biến `replacement` chứa chuỗi thay thế là "red".
# 5. Hàm `re.sub()` được sử dụng để thay thế tất cả các chuỗi khớp với `pattern` trong `text` bằng `replacement`.
# 6. Kết quả được lưu trong biến `new_text` và được in ra màn hình.
