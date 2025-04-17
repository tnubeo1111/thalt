# Identity Operations in Python

## Giới Thiệu

Các toán tử nhận dạng (identity operators) trong Python được sử dụng để so sánh vị trí bộ nhớ của hai đối tượng nhằm xác định xem chúng có phải là cùng một đối tượng hay không. Hai toán tử nhận dạng là "is" và "is not."

## Danh Sách Các Toán Tử Nhận Dạng

1. **is:** Trả về `True` nếu cả hai toán hạng tham chiếu đến cùng một đối tượng.
2. **is not:** Trả về `True` nếu cả hai toán hạng tham chiếu đến các đối tượng khác nhau.

### Ví Dụ

#### Toán Tử is

```python
x = [1, 2, 3]
y = x  # y bây giờ tham chiếu đến cùng một đối tượng với x
result = x is y
# result sẽ là True
```

#### Toán Tử is not

```python
a = "hello"
b = "world"
result = a is not b
# result sẽ là True
```