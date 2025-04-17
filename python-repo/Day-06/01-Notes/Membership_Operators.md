# Membership Operations in Python

## Giới Thiệu

Các toán tử thành viên trong Python được sử dụng để kiểm tra xem một giá trị có tồn tại trong một dãy hoặc tập hợp, chẳng hạn như danh sách, tuple, hoặc chuỗi. Các toán tử thành viên bao gồm "in" và "not in."

## Danh Sách Các Toán Tử Thành Viên

1. **in:** Trả về `True` nếu toán hạng bên trái được tìm thấy trong dãy hoặc tập hợp bên phải.
2. **not in:** Trả về `True` nếu toán hạng bên trái không được tìm thấy trong dãy hoặc tập hợp bên phải.

### Ví Dụ

#### Toán Tử in

```python
fruits = ["apple", "banana", "cherry"]
result = "banana" in fruits
# result will be True
```

#### Toán Tử not in

```python
colors = ["red", "green", "blue"]
result = "yellow" not in colors
# result will be True
```