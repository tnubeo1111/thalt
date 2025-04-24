# tìm file cần tìm trong python

# Viết script tìm kiếm file trong một thư mục (bao gồm thư mục con) theo tên file.
# Gợi ý: os, os.path, glob, hoặc pathlib.
# Note:
#     # - os.walk() để duyệt qua tất cả các thư mục con
#     # - os.path.join() để tạo đường dẫn đầy đủ
import os

def find_file(directory, filename):
    for root, dirs, files in os.walk(directory):
        if filename in files:
            print(os.path.join(root, filename))
            return
    print(f"File '{filename}' không tìm thấy trong thư mục '{directory}'.")

if __name__ == "__main__":
    directory = input("Nhập đường dẫn thư mục: ")
    filename = input("Nhập tên file cần tìm: ")
    if os.path.isdir(directory):
        find_file(directory, filename)
    else:
        print("Đường dẫn không hợp lệ.")