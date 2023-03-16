
#!/bin/bash
sleep 20s

if [[ $(kubectl -n west-prod rollout status deploy ${deploymentName} --timeout 5s) != *"successfully rolled out"* ]]; 
then     
	echo "Deployment ${deploymentName} Rollout has Failed"
    kubectl -n west-prod rollout undo deploy ${deploymentName}
    exit 1;
else
	echo "${deploymentName} deployment Rollout status in west is Success!!! Nothing To Do,Enjoy"
fi