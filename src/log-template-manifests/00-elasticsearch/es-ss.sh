kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: elasticsearch
  namespace: log
  labels:
    need_pv: "true"
    service: elasticsearch
spec:
  serviceName: elasticsearch
  # NOTE: This is number of nodes that we want to run
  # you may update this
  replicas: 3
  selector:
    matchLabels:
      service: elasticsearch
  template:
    metadata:
      labels:
        service: elasticsearch
    spec:
      terminationGracePeriodSeconds: 300
      # init containers for production ready setup
      initContainers:
      - name: fix-permissions
        image: busybox
        command: ["sh", "-c", "chown -R 1000:1000 /usr/share/elasticsearch/data"]
        securityContext:
          privileged: true
        volumeMounts:
        - name: elasticsearch-storage-volume
          mountPath: /usr/share/elasticsearch/data
      - name: increase-vm-max-map
        image: busybox
        command: ["sysctl", "-w", "vm.max_map_count=262144"]
        securityContext:
          privileged: true
      - name: increase-fd-ulimit
        image: busybox
        command: ["sh", "-c", "ulimit -n 65536"]
        securityContext:
          privileged: true
      # vlume
      volumes:
        - name: elasticsearch-storage-volume
          persistentVolumeClaim:
            claimName: elasticsearch-claim
      containers:
      - name: elasticsearch
        image: docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4
        ports:
        - containerPort: 9200
          name: http
        - containerPort: 9300
          name: tcp
        # NOTE: you can increase this resources
        resources:
          requests:
            cpu: 100m
            memory: 1Gi
          limits:
            cpu: 2
            memory: 2Gi
        env:
          # NOTE: the cluster name; update this
          - name: cluster.name
            value: elasticsearch-cluster
          - name: node.name
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          # NOTE: This will tell the elasticsearch node where to connect to other nodes to form a cluster
          - name: discovery.zen.ping.unicast.hosts
            #value: "elasticsearch-0.elasticsearch.log.svc.cluster.local"
            value: "elasticsearch-0.elasticsearch.log.svc.cluster.local,elasticsearch-1.elasticsearch.log.svc.cluster.local,elasticsearch-2.elasticsearch.log.svc.cluster.local"
          # NOTE: You can increase the heap size
          - name: ES_JAVA_OPTS
            value: -Xms512m -Xmx512m
        volumeMounts:
        - name: elasticsearch-storage-volume
          mountPath: /usr/share/elasticsearch/data
  volumeClaimTemplates:
  - metadata:
      name: elasticsearch-storage-volume
      labels:
        app: elasticsearch
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: fst-${REGION}-${ZONE_POSFIX_1}-${ZONE_POSFIX_2}
      resources:
        requests:
          storage: 10Gi
EOF
