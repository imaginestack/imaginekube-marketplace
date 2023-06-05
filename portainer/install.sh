#!/bin/sh

case $EDITION in
  ce)
    kubectl apply -f https://raw.githubusercontent.com/imaginekube/kubernetes-marketplace/master/portainer/ce-app.yaml
    ;;
  ee)  
    kubectl apply -f https://raw.githubusercontent.com/imaginekube/kubernetes-marketplace/master/portainer/ee-app.yaml
    ;;
esac

