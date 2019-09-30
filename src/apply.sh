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
kubectl apply -f log-manifets/others/elastic-crd.yaml

echo "--- install Istio Sidecar on log namespace ---"
kubectl apply -f log-manifets/others/istio-sidecar.yaml

echo "--- install elasticsearch cluster ---"
log-manifests/00-elasticsearch/es.sh

echo "--- install Fluentd Daemonset log collector  ---"
kubectl apply -f log-manifests/10-fluentd

echo "--- install Kibana ---"
log-manifests/20-kibana/kibana.sh