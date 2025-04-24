# Ping một danh sách các IP hoặc domain và in kết quả (thành công/thất bại).

# Gợi ý: dùng subprocess gọi ping, hoặc socket + requests.

# Note:
    # - stdout=subprocess.DEVNULL là để ẩn kết quả ping

import subprocess

def ping(host):
    output = subprocess.run(['ping', '-c', '4', host], capture_output=True, text=True)
    if output.returncode == 0:
        print(f"{host} is reachable")
    else:
        print(f"{host} is not reachable")
        
if __name__ == "__main__":
    hosts = input("Nhập danh sách IP hoặc domain (cách nhau bởi dấu phẩy): ").split(', ')
    print("Đang kiểm tra kết nối...")
    for host in hosts:
        ping(host)