#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 15s

if [[ $(kubectl -n north-mpm rollout status deploy ${northDeploy} --timeout 5s) != *"successfully rolled out"* ]];
then
	echo "Deployment ${northDeploy} Rollout has Failed"
    kubectl -n north-mpm rollout undo deploy ${northDeploy}
    exit 1;
else
	echo "Deployment ${northDeploy} Rollout Status is Success"
fi
