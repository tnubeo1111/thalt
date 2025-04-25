# Mục tiêu: Làm quen với việc sử dụng Python để giám sát hệ thống, một tác vụ phổ biến trong DevOps.

# Bài tập:

# Viết một script Python để:
# Kiểm tra xem một danh sách các URL (ví dụ: ["http://google.com", "http://example.com"]) có đang hoạt động hay không (HTTP status code 200).

import requests
import re

def check_url_status(url):
    if not re.match(r'^https?://', url):
        url = 'http://' + url
    try:
        output = requests.get(url, timeout=5)
        if output.status_code == 200:
            status = "UP"
            print(f"{url} is reachable")
            return status, url  
        else:
            status = "DOWN"
            print(f"{url} is not reachable")
            return status, url
    except requests.exceptions.RequestException as e:
        print (f"Error checking {url}: {e}")
        return "DOWN", url

def open_file(file_path):
    with open(file_path, 'r') as file:
        # Đọc từng dòng, loại bỏ khoảng trắng và ký tự xuống dòng
        lines = [line.strip() for line in file.readlines() if line.strip()]
        return lines
    
if __name__ == "__main__":
    # urls = input("Nhập danh sách URL (cách nhau bởi dấu phẩy): ").split(', ')
    file_path = input("Nhập đường dẫn đến file chứa danh sách URL: ")
    urls = open_file(file_path)
    print("Đang kiểm tra trạng thái server...")
    for url in urls:
        check_url_status(url)