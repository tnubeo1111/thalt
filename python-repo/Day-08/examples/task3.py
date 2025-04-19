# Bài tập 3: Kết hợp List và Tuple
# Tạo một list chứa 3 tuple, mỗi tuple chứa tọa độ (x, y) của một điểm trên mặt phẳng.
# In tọa độ của điểm thứ 2.
# Thêm một tọa độ mới vào list.
# In lại toàn bộ list.

# Bước 1: Tạo một list chứa 3 tuple, mỗi tuple chứa tọa độ (x, y) của một điểm trên mặt phẳng
coordinates = [(1, 3), (2, 5), (3, 7)]
print("Initial list of coordinates:", coordinates)

# Bước 2: In tọa độ của điểm thứ 2
print("Coordinates of the second point:", coordinates[1])

# Bước 3: Thêm một tọa độ mới vào list
coordinates.append((4, 9))
print("List after adding a new coordinate:", coordinates)