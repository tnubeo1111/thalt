# Cách hoạt động:
# os.path.join(folder, file): Tạo đường dẫn đầy đủ đến từng tệp trong thư mục.
# os.path.isfile(file_path): Kiểm tra xem đường dẫn có phải là tệp không (bỏ qua thư mục con).
# os.path.getsize(file_path): Lấy kích thước của từng tệp và cộng dồn vào total_size.

import os


def size_of_folder(folder):
    try:
        total_size = 0
        list_files = os.listdir(folder)
        for file in list_files:
            file_path = os.path.join(folder, file)
            if os.path.isfile(file_path):  # Chỉ tính kích thước của tệp
                total_size += os.path.getsize(file_path)
        return total_size, None
    except FileNotFoundError:
        return None, "Folder not found."
    except PermissionError:
        return None, "Permission denied for folder."
    
def main():
    folder_path = input("Please enter the folder names (separated by spaces): ").split()
    for folder in folder_path:
        files, error_message = size_of_folder(folder)
        if files:
            print(f"Size of {folder}: {files} bytes")
        else:
            print(f"Error in {folder}: {error_message}")
        print("-------------------------------------------------")

if __name__ == "__main__":
    main()
