# Mô tả: Viết một script Python sử dụng Boto3 để tạo một S3 bucket với tên do người dùng nhập. Kiểm tra xem bucket đã được tạo thành công chưa.

# Hướng dẫn:

# Sử dụng hàm create_bucket của Boto3.
# Kết hợp kiến thức Python: nhập dữ liệu từ người dùng (input), xử lý lỗi nếu bucket đã tồn tại.

import boto3
import re

# Khởi tạo client S3
s3_client = boto3.client('s3')

def is_valid_bucket_name(bucket_name):
    # Quy tắc: 3-63 ký tự, chữ thường, số, dấu gạch ngang, không chứa ký tự đặc biệt
    pattern = r'^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$'
    return bool(re.match(pattern,bucket_name))

def create_s3_bucket(bucket_name, region='ap-southeast-2'):
    try:
        # Kiểm tra tên bucket hợp lệ
        if not is_valid_bucket_name(bucket_name):
            print("Error: '{bucket_name}' không hợp lệ! ")
            print("Tên bucket phải từ 3-63 ký tự, chỉ chứa chữ thường, số và dấu gạch ngang.")
            return

        # Tạo Bucket
        if region == 'us-east-1':
            s3_client.create_bucket(Bucket=bucket_name)
        else:
            s3_client.create_bucket(
                Bucket=bucket_name,
                CreateBucketConfiguration={'LocationConstraint': region}
            )
        print(f"Bucket '{bucket_name}' đã được tạo thành công ở vùng '{region}'")
    except s3_client.exceptions.BucketAlreadyExists:
        print(f"Error: Bucket '{bucket_name}' đã tồn tại!")
    except s3_client.exceptions.BucketAlreadyOwnedByYou:
        print(f"Error: Bạn đã sở hữu bucket '{bucket_name}' này!")
    except Exception as e:
        print(f"Error: Không thể tạo bucket '{bucket_name}'. Lỗi: {e}")
        
if __name__ == "__main__":
    bucket_name = input("Nhập tên bucket (chữ thường, số, dấu gạch ngang, 3-63 ký tự): ")
    region = input("Nhập vùng AWS (ví dụ: us-east-1, us-west-2, để trống để mặc định ap-southeast-2): ") or 'ap-southeast-2'

    # Khởi tạo client S3
    create_s3_bucket(bucket_name, region)