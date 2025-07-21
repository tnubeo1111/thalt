# step 1
kubectl edit configmap -n kube-system kube-proxy

# step 2
apiVersion: kubeproxy.config.k8s.io/v1alpha1
kind: KubeProxyConfiguration
mode: "ipvs"
ipvs:
  strictARP: true

# step 3
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml

# step 4

kubectl apply -f metallb-conf.yaml 

# Fix Error 

## Error from server (InternalError): error when creating "config.yaml": Internal error occurred: failed calling webhook "ipaddresspoolvalidationwebhook.metallb.io": failed to call webhook: Post "https://metallb-webhook-service.metallb-system.svc:443/validate-metallb-io-v1beta1-ipaddresspool?timeout=10s": context deadline exceeded
## Error from server (InternalError): error when creating "config.yaml": Internal error occurred: failed calling webhook "l2advertisementvalidationwebhook.metallb.io": failed to call webhook: Post "https://metallb-webhook-service.metallb-system.svc:443/validate-metallb-io-v1beta1-l2advertisement?timeout=10s": dial tcp 10.104.252.91:443: i/o timeout

kubectl get validatingwebhookconfigurations

kubectl delete validatingwebhookconfiguration metallb-webhook-configuration

kubectl rollout restart deployment -n metallb-system

kubectl apply -f config.yaml

