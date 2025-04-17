# Bitwise Operations in Python

## Giới Thiệu

Các toán tử bitwise trong Python được sử dụng để thực hiện các phép toán trên từng bit của các số nhị phân. Các toán tử này bao gồm bitwise AND, OR, XOR, và nhiều toán tử khác.

## Danh Sách Các Toán Tử Bitwise

1. **Bitwise AND (&):** Thực hiện phép toán AND trên từng bit của các toán hạng.
2. **Bitwise OR (|):** Thực hiện phép toán OR trên từng bit.
3. **Bitwise XOR (^):** Thực hiện phép toán XOR trên từng bit.
4. **Bitwise NOT (~):** Đảo ngược các bit của toán hạng, chuyển 0 thành 1 và 1 thành 0.
5. **Left Shift (<<):** Dịch các bit sang trái một số vị trí được chỉ định.
6. **Right Shift (>>):** Dịch các bit sang phải.

## Ví Dụ

### Bitwise AND

```python
a = 5  # Binary: 0101
b = 3  # Binary: 0011
result = a & b  # Result: 0001 (Decimal: 1)
```

### Bitwise OR

```python
x = 10  # Binary: 1010
y = 7   # Binary: 0111
result = x | y  # Result: 1111 (Decimal: 15)
```