## Bài tập 1: Cơ bản về List
# Tạo một list chứa 5 loại trái cây yêu thích của bạn.
# Thêm một loại trái cây mới vào cuối list bằng append().
# Xóa loại trái cây ở vị trí thứ 2 bằng pop().
# In list sau mỗi bước.

# Bước 1: Tạo một list chứa 5 loại trái cây yêu thích
def list_fruits():
    fruits = ["Apple", "Banana", "Cherry", "Mango", "Orange"]
    return fruits

# Bước 2: Thêm một loại trái cây mới vào cuối list bằng append()
def add_fruit():
    add = list_fruits()
    add.append("Grapes")
    return add

# Bước 3: Xóa loại trái cây ở vị trí thứ 2 bằng pop()
def remove_fruit():
    remove = list_fruits()
    remove.pop(2)
    return remove