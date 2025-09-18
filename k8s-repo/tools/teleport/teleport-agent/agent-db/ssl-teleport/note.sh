kubectl exec -i -n teleport deployment/teleport-auth -- tctl auth sign --format=db --host=hihi.example.com --out=/tmp/server --ttl=85600h

kubectl cp teleport/teleport-auth-7d5fdb9dd7-qx7w8:/tmp/server.cas ./server.cas
kubectl cp teleport/teleport-auth-7d5fdb9dd7-qx7w8:/tmp/server.key ./server.key
kubectl cp teleport/teleport-auth-7d5fdb9dd7-qx7w8:/tmp/server.crt ./server.crt
