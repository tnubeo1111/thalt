import re

text = "The quick brown fox"
pattern = r"quick"

match = re.match(pattern, text)
if match:
    print("Match found:", match.group())
else:
    print("No match")

# Ghi chú:
# - Đoạn mã trên sử dụng thư viện `re` (regular expression) để kiểm tra xem chuỗi `text` có khớp với mẫu `pattern` hay không.
# - Hàm `re.match()` chỉ kiểm tra khớp từ đầu chuỗi. Nếu mẫu không xuất hiện ở đầu chuỗi, kết quả sẽ là `None`.
# - Trong ví dụ này, mẫu `quick` không nằm ở đầu chuỗi `text`, do đó kết quả là "No match".
