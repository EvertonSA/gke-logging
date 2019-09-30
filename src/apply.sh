###################################################################
#Script Name	: 10-build-log-objects.sh
#Description	: 
#Args          	: no args needed, but need to edit values.sh file
#Author       	: Everton Seiei Arakaki
#Email         	: eveuca@gmail.com
###################################################################

# import variables in script context
source values.sh

gcloud config set project $PROJECT_ID

echo "--- install Elastic Custom Resource Definitions ---"
kubectl apply -f log-manifests/others/elastic-crd.yaml && sleep 10s

echo "--- install Istio Sidecar on log namespace ---"
kubectl apply -f log-manifests/others/istio-sidecar.yaml && sleep 10s

echo "--- install elasticsearch cluster ---"
log-manifests/00-elasticsearch/es.sh

while [[ $(kubectl get elasticsearch -n log elasticsearch -o jsonpath='{.status.health}') != "green" ]]; do
  echo "waiting for elasticsearch cluster to be ready!" && sleep 10s; 
done

echo "--- install Fluentd Config as K8S configMap  ---"
OPS_PASSWORD=$(kubectl -n log get secret elasticsearch-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode)
. ./log-manifests/10-fluentd/fluentd-cm.sh

echo "--- install Fluentd Daemonset log collector  ---"
kubectl apply -f log-manifests/10-fluentd/fluentd-ds-es.yaml && sleep 10s;

echo "--- install Kibana ---"
log-manifests/20-kibana/kibana.sh