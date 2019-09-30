kubectl apply -f - <<EOF
apiVersion: kibana.k8s.elastic.co/v1alpha1
kind: Kibana
metadata:
  name: kibana
  namespace: log
spec:
  version: 7.2.0
  nodeCount: 1
  elasticsearchRef:
    name: elasticsearch
  http:
    tls:
      selfSignedCertificate:
        disabled: true    
EOF