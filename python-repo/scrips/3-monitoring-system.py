# Script giám sát dung lượng ổ đĩa
# Cảnh báo nếu dung lượng ổ đĩa vượt ngưỡng (ví dụ: > 80%).

# Gợi ý: psutil.

import psutil

def check_disk_usage(threshold_disk):
    disk_usage = psutil.disk_usage('/')
    percent_used = disk_usage.percent

    if percent_used > threshold_disk:
        print(f"Cảnh báo: Dung lượng ổ đĩa đã sử dụng {percent_used}%")
    else:
        print(f"Dung lượng ổ đĩa đang ở mức an toàn: {percent_used}%")

def check_ram_usage(threshold_ram):
    ram_usage = psutil.virtual_memory()
    percent_used = ram_usage.percent

    if percent_used > threshold_ram:
        print(f"Cảnh báo: Dung lượng RAM đã sử dụng {percent_used}%")
    else:
        print(f"Dung lượng RAM đang ở mức an toàn: {percent_used}%")

def check_cpu_usage(threshold_cpu):
    cpu_usage = psutil.cpu_percent(interval=1)
    if cpu_usage > threshold_cpu:
        print(f"Cảnh báo: CPU đang sử dụng {cpu_usage}%")
    else:
        print(f"CPU đang ở mức an toàn: {cpu_usage}%")

if __name__ == "__main__":
    theshold_disk = 300  # Ngưỡng cảnh báo
    theshold_ram = 20  # Ngưỡng cảnh báo
    theshold_cpu = 80  # Ngưỡng cảnh báo
    check_disk_usage(theshold_disk)
    check_ram_usage(theshold_ram)
    check_cpu_usage(theshold_cpu)