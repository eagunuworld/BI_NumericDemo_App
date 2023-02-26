#!/bin/bash

#k8s-deployment-rollout-status.sh

sleep 60s

if [[ $(kubectl -n qa get deploy ${deploymentName} --timeout 5s) = *"successfully rolled out"* ]];
then
	echo "Deployment ${deploymentName} was successful"
    exit 0;
else
	kubectl -n qa rollout undo deploy ${deploymentName}
	echo "Deployment ${deploymentName} Rollout is Success"
fi

#
# if [[ $(kubectl -n default rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]];
# then
# 	echo "Deployment ${deploymentName} Rollout has Failed"
#     kubectl -n default rollout undo deploy ${deploymentName}
#     exit 1;
# else
# 	echo "Deployment ${deploymentName} Rollout is Success"
# fi
