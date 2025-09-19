Create separate folders for users who need to connect to client-certificate authenticated
# PostgreSQL instances. Each user should have their own folder with a private key
# and a client certificate.
# The private key should be protected with chmod 400.
# The client certificate should be protected with chmod 444.

Example:
# mkdir -p /path/to/ssl/users/user1
# chmod 700 /path/to/ssl/users/user1
# openssl genrsa -out /path/to/ssl/users/user1/user1.key 2048
# chmod 400 /path/to/ssl/users/user1/user1.key
# openssl req -new -key /path/to/ssl/users/user1/user1.key -out /path/to/ssl/users/user1/user1.csr -subj "/CN=user1"
# openssl x509 -req -in /path/to/ssl/users/user1/user1.csr -CA /path/to/ssl/ca/ca.crt -CAkey /path/to/ssl/ca/ca.key -CAcreateserial -out /path/to/ssl/users/user1/user1.crt -days 365 -sha256
# chmod 444 /path/to/ssl/users/user1/user1.crt
# rm /path/to/ssl/users/user1/user1.csr
# rm /path/to/ssl/ca/ca.srl
# echo "User user1 SSL setup complete." 
