# Bài tập 2: Cơ bản về Tuple
# Tạo một tuple chứa 3 thông tin: tên, tuổi, và nghề nghiệp của bạn.
# In phần tử thứ 2 của tuple.
# Thử thay đổi phần tử đầu tiên của tuple và quan sát lỗi.
# Đếm số lần xuất hiện của một giá trị bất kỳ trong tuple (ví dụ: tuổi).

info = ("Thanh Tha", 25, "DevOps Engineer")
print("Tuple info:", {info})

# In phần tử thứ 2 của tuple
print("Second element of tuple:", info[1])

# Thử thay đổi phần tử đầu tiên của tuple và quan sát lỗi
# info[1] = 26  # This will raise a TypeError because tuples are immutable
# print("After trying to change the first element:", info)

# Đếm số lần xuất hiện của một giá trị bất kỳ trong tuple
age_count = info.count(25)
print("Count of age 25 in tuple:", age_count)