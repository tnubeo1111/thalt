# Dictionaries

## Overview:
Từ điển trong Python là một cấu trúc dữ liệu cho phép lưu trữ và truy xuất giá trị bằng cách sử dụng khóa. Nó còn được gọi là hashmap hoặc mảng liên kết trong các ngôn ngữ lập trình khác. Từ điển được triển khai dưới dạng bảng băm, cung cấp khả năng truy cập nhanh vào các giá trị dựa trên khóa của chúng.

## Creating a Dictionary:
```python
my_dict = {'name': 'John', 'age': 25, 'city': 'New York'}
```

## Accessing Values:
```python
print(my_dict['name'])  # Output: John
```

## Modifying and Adding Elements:
```python
my_dict['age'] = 26  # Modifying a value
my_dict['occupation'] = 'Engineer'  # Adding a new key-value pair
```

## Removing Elements:
```python
del my_dict['city']  # Removing a key-value pair
```

## Checking Key Existence:
```python
if 'age' in my_dict:
    print('Age is present in the dictionary')
```

## Iterating Through Keys and Values:
```python
for key, value in my_dict.items():
    print(key, value)
```