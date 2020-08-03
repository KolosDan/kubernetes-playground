# CA path could vary from setup to setup. Check on node /etc/manifests/kube-apiserver.yaml -> args -> front-proxy-ca. Cert is likely to be in /etc/kubernetes/pki/front-proxy-ca.crt
kubectl -nkube-system create configmap front-proxy-ca --from-file=front-proxy-ca.crt=/etc/kubernetes/pki/front-proxy-ca.crt -o yaml | kubectl -nkube-system replace configmap front-proxy-ca -f -