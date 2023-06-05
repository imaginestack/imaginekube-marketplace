helm uninstall imaginekube -n=okteto
kubectl delete secret default-ssl-certificate imaginekube-cert-registry imaginekube-cert-ingress -n=okteto
kubectl delete ns okteto