#!/bin/bash

while ! kubectl apply -f https://raw.githubusercontent.com/imaginekube/kubernetes-marketplace/master/kubeflow/kubeflow.yaml; do echo "Retrying to apply resources"; sleep 10; done