#!/bin/bash

echo "All args:[ $@ ]"

DESIRED_KOPS_CLUSTER_NAME=$1
DNS_DOMAIN_NAME=$2
GCE_ZONE=$3
#"kops-test.nlpnp.adsdcsp.com"
MINIO_ACCESS_KEY="my_minio_key"
MINIO_SECRET_KEY="my_minio_secret"
MINIO_URL=minio.$DNS_DOMAIN_NAME

export ISSUER=https://dex.$DNS_DOMAIN_NAME:443/dex # change 443 port if using kubernetes node port instead of load balancer
export DEX_NAMESPACE=dex
export DEX_DOMAIN_NAME=dex.$DNS_DOMAIN_NAME
export DOMAIN_NAME=$DNS_DOMAIN_NAME

export HELM_TEMP_DIR=`pwd`/helm-temp-dir

cd ..
rm -fr $HELM_TEMP_DIR
cp -r helm-deployment $HELM_TEMP_DIR
cd -


. utils/validate_envs.sh
. utils/progress_bar.sh
. utils/wait_for_pod.sh
. utils/messages.sh


if [ ! -z "$DESIRED_KOPS_CLUSTER_NAME" ]; then
cd k8s
. create_cluster.sh $DESIRED_KOPS_CLUSTER_NAME $GCE_ZONE
. install_tiller.sh 
cd ..
fi

cd ingress
. install.sh
cd ..

cd crd
. install.sh $DNS_DOMAIN_NAME
cd ..

cd dns
. setup.sh $DNS_DOMAIN_NAME 
cd ..

cd minio
. install.sh $MINIO_ACCESS_KEY $MINIO_SECRET_KEY $MINIO_URL
cd ..

cd ldap
. install.sh
cd ..

cd dex
. install.sh $ISSUER $DEX_NAMESPACE $DEX_DOMAIN_NAME
cd .. 

pwd 

cd validate
.  ./test_dex_ldap.sh https://$DEX_DOMAIN_NAME
cd ..

if [ ! -z "$DESIRED_KOPS_CLUSTER_NAME" ]; then
cd k8s
. ./restart_k8sapi.sh $DESIRED_KOPS_CLUSTER_NAME $ISSUER $DEX_NAMESPACE 
cd ..
else
cd k8s
DEX_CA=`./get_ca_ing_cert.sh`
action_required "Please restart K8S API with OIDC config: issuer: $ISSUER: CA: $DEX_CA"
read -p "Press [ENTER] when ready"
cd -
fi

cd mgtapi
. ./install.sh $DOMAIN_NAME $MINIO_ACCESS_KEY $MINIO_SECRET_KEY $MINIO_URL 
show_result $? "Done" "Aborting"
cd ..


