#!/bin/sh

here=`dirname $(realpath $0)`

kubectl create ns flux-system --dry-run=client -o yaml | kubectl --context=k3d-kyma apply -f -
cat $here/flux-istio.yml | kubectl --context=k3d-kyma apply -f -

cat $here/flux-install.yml | kubectl --context=k3d-kyma apply -f -
cat $here/flux-system-source.yml | kubectl --context k3d-kyma apply -f -
cat $here/flux-system-kustomization.yml | kubectl --context k3d-kyma apply -f -
