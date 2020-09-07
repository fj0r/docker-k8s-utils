#!/bin/bash

if [ -z ${PLUGIN_NAMESPACE} ]; then
  PLUGIN_NAMESPACE="default"
fi

if [ -z ${PLUGIN_KUBERNETES_PORT} ]; then
  PLUGIN_KUBERNETES_PORT="6443"
fi

if [ -z ${PLUGIN_KUBERNETES_PROTOCOL} ]; then
  PLUGIN_KUBERNETES_PROTOCOL="https"
fi

if [ -z ${PLUGIN_HOSTNAME} ]; then
  PLUGIN_KUBERNETES_SERVER=${PLUGIN_KUBERNETES_SERVER}
else
  PLUGIN_KUBERNETES_SERVER=${PLUGIN_HOSTNAME}
  echo "${PLUGIN_KUBERNETES_SERVER} ${PLUGIN_HOSTNAME}" >> /etc/hosts
fi

yq w -i ${KUBECONFIG} 'users[0].user.token' ${PLUGIN_KUBERNETES_TOKEN}
yq w -i ${KUBECONFIG} 'clusters[0].cluster.certificate-authority-data' ${PLUGIN_KUBERNETES_CERT}
yq w -i ${KUBECONFIG} 'clusters[0].cluster.server' "${PLUGIN_KUBERNETES_PROTOCOL}://${PLUGIN_KUBERNETES_SERVER}:${PLUGIN_KUBERNETES_PORT}"
yq w -i ${KUBECONFIG} 'contexts[0].context.namespace' ${PLUGIN_NAMESPACE}


IFS=',' read -r -a cmds <<< "${PLUGIN_SCRIPT}"
for cmd in "${cmds[@]}"; do
eval $cmd
done
