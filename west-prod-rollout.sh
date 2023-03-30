
#!/bin/bash
sleep 20s

if [[ $(kubectl -n west-prod rollout status deploy ${westdDeploy} --timeout 5s) != *"successfully rolled out"* ]]; 
then     
	echo "Deployment ${westdDeploy} Rollout has Failed"
    kubectl -n west-prod rollout undo deploy ${westdDeploy}
    exit 1;
else
	echo "Deployment ${westdDeploy} Rollout in west is Success"
fi
