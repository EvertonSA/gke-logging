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

echo "--- install log objects ---"
. ../template-manifests/log-template-manifests/00-elasticsearch/es-ss.sh
kubectl apply -f ../template-manifests/log-template-manifests/00-elasticsearch
kubectl apply -f ../template-manifests/log-template-manifests/10-fluentd
kubectl apply -f ../template-manifests/log-template-manifests/20-kibana