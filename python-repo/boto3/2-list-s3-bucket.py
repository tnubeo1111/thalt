import boto3


# Khởi tạo client S3
s3_client = boto3.client('s3')

def get_region_bucket(bucket_name):
    print(f"Đang lấy thông tin vùng của bucket '{bucket_name}'...")
    try:
        # Lấy thông tin vùng của bucket
        response = s3_client.get_bucket_location(Bucket=bucket_name)
        location = response.get('LocationConstraint') or 'us-east-1'
        return location
    except Exception as e:
        print(f"Error: Không thể lấy thông tin vùng của bucket '{bucket_name}'. Lỗi: {e}")

def list_s3_buckets():
    try:
        # Lấy danh sách các bucket
        response = s3_client.list_buckets()

        # Kiểm tra xem có bucket nào không
        buckets = response.get('Buckets', [])
        if not buckets:
            print("Không có bucket nào trong tài khoản AWS của bạn.")
            return
        # In danh sách các bucket
        print("Danh sách các bucket:")
        for bucket in buckets:
            region = get_region_bucket(bucket['Name'])
            creation_date = bucket['CreationDate'].strftime('%Y-%m-%d %H:%M:%S')
            print(f"- {bucket['Name']} - Vùng: {region} - Ngày tạo: { creation_date}")
    except Exception as e:
        print(f"Error: Không thể lấy danh sách bucket. Lỗi: {e}")

if __name__ == "__main__":
    # Liệt kê các bucket
    list_s3_buckets()
