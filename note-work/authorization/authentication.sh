Khi bạn sử dụng lệnh curl để lấy token với thông tin đăng nhập, server sẽ thực hiện quá trình xác thực và cấp phát token theo trình tự sau đây. Đây là quá trình diễn ra khi client yêu cầu JWT token từ server thông qua cú pháp:

curl -u "test:12341234**" -X GET "https://test.infiniband.vn/service/token?scope=repository:hehe/busybox:pull&service=harbor-registry"

Giải thích từng thành phần của lệnh curl:
-u "test:12341234**": Thông tin đăng nhập, trong đó test là username và 12341234** là password. Lệnh curl sẽ tự động chuyển thông tin này thành chuỗi Authorization Basic theo chuẩn HTTP Basic Authentication (sẽ giải thích chi tiết bên dưới).

-X GET: Thực hiện yêu cầu GET tới URL chỉ định, trong trường hợp này là endpoint để lấy token từ server.

URL "https://test.infiniband.vn/service/token?scope=repository:hehe/busybox:pull&service=harbor-registry": Đây là endpoint của hệ thống mà bạn gửi yêu cầu để lấy token. Các tham số:

scope: Phạm vi của token, xác định rằng token chỉ dùng để pull image từ repository hehe/busybox.
service: Tên dịch vụ, ở đây là harbor-registry, tên của registry mà client muốn truy cập.

Quy trình cụ thể mà server xử lý yêu cầu:
1. Client gửi yêu cầu với Basic Authentication
Khi lệnh curl được thực thi với tùy chọn -u "test:12341234**", curl sẽ mã hóa thông tin đăng nhập thành chuỗi Base64 và thêm vào header của HTTP request theo định dạng Authorization: Basic <base64encoded_credentials>. Ví dụ:

Username: test
Password: 12341234**
Thông tin này được mã hóa thành chuỗi Base64:

Authorization: Basic dGVzdDoxMjM0MTIzNDIqKg==

Lệnh curl sẽ gửi yêu cầu GET với header chứa thông tin trên tới server https://test.infiniband.vn/service/token.

2. Server nhận yêu cầu và xác thực thông tin
Bước 1: Server nhận được request, đọc thông tin từ header Authorization: Basic dGVzdDoxMjM0MTIzNDIqKg==.

Bước 2: Server giải mã Base64 chuỗi này để lấy ra thông tin đăng nhập: test:12341234**.

Bước 3: Server sẽ kiểm tra tính hợp lệ của thông tin đăng nhập này trong hệ thống (so sánh với cơ sở dữ liệu chứa username và password của người dùng).

Nếu thông tin đăng nhập chính xác, server sẽ tiến hành bước tiếp theo.
Nếu thông tin sai, server sẽ trả về lỗi 401 Unauthorized.

3. Tạo JWT Token cho client
Sau khi xác thực thành công thông tin đăng nhập, server sẽ tạo một JWT token dựa trên phạm vi yêu cầu (scope) và dịch vụ (service) từ URL.

Scope: repository:hehe/busybox:pull chỉ ra rằng token này chỉ có quyền pull (kéo image) từ repository hehe/busybox.
Service: harbor-registry chỉ định registry mà client muốn truy cập.

Tạo JWT token:
Header: Định nghĩa thuật toán dùng để ký (HS256).
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload: Chứa thông tin như username của người dùng và phạm vi truy cập. Ví dụ:
{
  "sub": "test",  // Username
  "aud": "harbor-registry",
  "exp": 1691251200 // Thời gian hết hạn của token
  "access": [
    {
      "type": "repository",
      "name": "hehe/grafana",
      "actions": [
        "delete",
        "pull",
        "push"
      ]
    }
  ]
}
Signature: Được tạo bằng cách ký header và payload bằng secret của server với thuật toán HS256.

Cuối cùng, server sẽ trả về token với định dạng:

<base64url_encoded_header>.<base64url_encoded_payload>.<base64url_encoded_signature>

4. Server gửi token về client
Kết quả của lệnh curl sẽ trả về một JWT token, ví dụ:
{
  "token": "eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9.eyJzdWIiOiJ0ZXN0Iiwic2NvcGUiOiJyZXBvc2l0b3J5OmhlaGUvYnVzeWJveDpwdWxsIiwic2VydmljZSI6ImhhcmJvci1yZWdpc3RyeSIsImV4cCI6MTY5MTI1MTIwMH0.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
}
Token này có thể sử dụng cho các yêu cầu sau để truy cập tài nguyên trong Harbor.

5. Client sử dụng token để truy cập
Sau khi nhận được token từ server, client sẽ lưu trữ nó và sử dụng cho các lần truy cập sau. Token này sẽ được gửi kèm trong header của các yêu cầu HTTP với cú pháp sau:

Authorization: Bearer <token>

Ví dụ, để kéo image từ hehe/busybox, client sẽ gửi yêu cầu với header như sau:

curl -i -H "Authorization:  Bearer ${bot}" -X GET https://test.infiniband.vn/v2/hehe/busybox/manifests/sha256:28e01ab32c9dbcbaae96cf0d5b472f22e231d9e603811857b295e61197e40a9b

Server sẽ xác minh token và trả về tài nguyên (image) nếu token hợp lệ.
