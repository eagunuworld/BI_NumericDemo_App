#!/bin/bash

#k8s-deployment.sh
deploymentName="devsecops"
containerName="devsecops-container"
serviceName="devsecops-svc"
#imageName="eagunuworld/numeric-app:docker pull eagunuworld/numeric-app:ddba18bd401f3eeb0ee097eb56dd8f76d1953e0b"
imageName="eagunuworld/numeric-app:ddba18bd401f3eeb0ee097eb56dd8f76d1953e0b"
applicationURL="http://devsecops-demo.eastus.cloudapp.azure.com/"
applicationURI="/increment/99"

#sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
echo $containerName
echo $deploymentName
kubectl -n qa get deployment ${deploymentName} > /dev/null

if [[ $? -ne 0 ]]; then
    echo "deployment ${deploymentName} doesnt exist"
    kubectl -n qa apply -f k8s_deployment_service.yaml
else
    echo "deployment ${deploymentName} exist"
    echo "image name - ${imageName}"
    kubectl -n qa set image deploy ${deploymentName} ${containerName}=${imageName} --record=true
fi
#!/bin/bash

# #k8s-deployment.sh
# # sh '''final_tag=$(echo $VERSION | tr -d ' ')
# #  echo ${final_tag}test
# #  sed -i "s/BUILD_TAG/$final_tag/g"  docker-compose.yml
# #  '''
#  #dockerimage=$(awk 'NR==1 {print $2}' Dockerfile)
#  final_tag=$(echo $VERSION | tr -d ' ')
#  echo ${final_tag}test
#  #echo $dockerimage
# sed -i "s/BUILD_TAG/$final_tag/g"  k8s_deployment_service.yaml
# #sed -i "s#replace#${imageName}#g" k8s_deployment_service.yaml
# kubectl -n default get deployment ${deploymentName} > /dev/null
#
# if [[ $? -ne 0 ]]; then
#     echo "deployment ${deploymentName} doesnt exist"
#     kubectl -n default apply -f k8s_deployment_service.yaml
# else
#     echo "deployment ${deploymentName} exist"
#     echo "image name - ${imageName}"
#     #kubectl -n default set image deploy ${deploymentName} ${containerName}=${imageName} #--record=true
# fi
