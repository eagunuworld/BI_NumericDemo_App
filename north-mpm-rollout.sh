#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 15s

if [[ $(kubectl -n north-mpm rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]];
then
	echo "Deployment ${deploymentName} Rollout has Failed"
    kubectl -n north-mpm rollout undo deploy ${deploymentName}
    exit 1;
else
	echo "Deployment ${deploymentName} Rollout Status is Success"
fi
