#!/usr/bin/env bash

curl -fsL https://run.linkerd.io/install | sh
linkerd version
linkerd check --pre
linkerd install | kubectl apply -f -
linkerd check
curl -fsL https://run.linkerd.io/emojivoto.yml | kubectl apply -f -
kubectl -n emojivoto port-forward svc/web-svc 8080:80
kubectl get -n emojivoto deploy -o yaml | linkerd inject - | kubectl apply -f -
export SERVICE_MESH=5
echo "ENDPOINT_URL=http://localhost:8080" >> $GITHUB_ENV
echo "SERVICE_MESH=$SERVICE_MESH" >> $GITHUB_ENV