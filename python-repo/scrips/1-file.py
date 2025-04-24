# Script liệt kê file
# Viết script liệt kê tất cả các file trong một thư mục (bao gồm thư mục con).

# Gợi ý: os, os.path, glob, hoặc pathlib.

import os

def list_files(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            print(os.path.join(root, file))

if __name__ == "__main__":
    directory = input("Nhập đường dẫn thư mục: ")
    if os.path.isdir(directory):
        list_files(directory)
    else:
        print("Đường dẫn không hợp lệ.")