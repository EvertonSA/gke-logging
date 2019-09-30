kubectl apply -f - <<EOF
apiVersion: elasticsearch.k8s.elastic.co/v1alpha1
kind: Elasticsearch
metadata:
  name: elasticsearch
spec:
  version: 7.2.0
  nodes:
  - nodeCount: 3
    config:
      node.master: true
      node.data: true
      node.ingest: true
EOF
