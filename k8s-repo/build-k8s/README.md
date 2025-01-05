# Nếu build cụm on-priems mà không có LB

Chúng ta sẽ sử dụng Metallb để setup, hiện tại tôi không có IP nào trông nên sẽ sử dụng IP của master hoặc worker để setup thành 1 IP LB. 

Nếu bạn sử dụng Ingress-nginx tôi khuyên bạn nên sử dụng service type Loadbalancer (default) thành ClusterIP và config thêm externalIP.

Vì nếu sử dụng svc default Loadbalancer thì IP của master hoặc worker sẽ là trạng thái ipMode: VIP như vậy các server ngoài Cluster sẽ không call tới các Ingress bên trong Cluster. 

Bạn có thể tham khảo config metallb của tôi "application/metallb/metallb-conf.yaml" với đoạn config này bạn lưu ý thêm về "interfaces" trong file yaml.
