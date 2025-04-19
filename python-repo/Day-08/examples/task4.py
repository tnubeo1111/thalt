# Bài tập 4: Ứng dụng List Comprehension
# Tạo một list chứa các số chẵn từ 1 đến 20 bằng list comprehension.
# Tạo một list chứa các chuỗi là tên trái cây viết hoa từ list trái cây ở Bài tập 1.

import task1
# Bước 1: Tạo một list chứa các số chẵn từ 1 đến 20 bằng list comprehension
event_numbers = [num for num in range(1, 21) if num % 2 == 0]
print("List of even numbers from 1 to 20:", event_numbers)

# Bước 2: Tạo một list chứa các chuỗi là tên trái cây viết hoa từ list trái cây ở Bài tập 1
fruits_upper = [list_fruit.upper() for list_fruit in task1.list_fruits()]

print("List of fruits in uppercase:", fruits_upper)