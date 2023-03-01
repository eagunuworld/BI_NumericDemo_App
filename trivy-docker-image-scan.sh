## trivy-docker-image-scan.sh
#!/bin/bash

dockerimage=$(awk 'NR==1 {print $2}' Dockerfile)
echo $dockerimage

docker run --rm -v $workspace:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerimage
docker run --rm -v $workspace:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerimage

# Trivy scan result processing
exit_code=$?
echo "Exit Code : $exit_code"

# Check scan results
if [[ "${exit_code}" == 1 ]]; then
    echo "Image scanning failed. Vulnerabilities found"
    exit 1;
else
    echo "Image scanning passed. No CRITICAL vulnerabilities found"
fi;


##############Testing this script from terminal, workspace there is dockerfile, this failed python:3.4-alpine
#image to fail the build  openjdk:8-jdk-alpine
# user@kubeadm-master:~/workspace/devsecops-playstation/devsecop-dev$
# dockerimage=$(awk 'NR==1 {print $2}' Dockerfile)
# echo $dockerimage
# adoptopenjdk/openjdk8:alpine-slim
# dockerimage=$(awk 'NR==1 {print $1}' Dockerfile)
# echo $dockerimage

# user@kubeadm-master:~$ docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  python:3.4-alpine
# 2023-02-06T21:02:28.131Z        INFO    Need to update DB
# 2023-02-06T21:02:28.131Z        INFO    DB Repository: ghcr.io/aquasecurity/trivy-db
# 2023-02-06T21:02:28.131Z        INFO    Downloading DB...



# docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy python:3.4
#   206  clear
#   207  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  python:3.4-alpine
#   208  clear
#   209  echo $dockerimage
#   210  dockerimage=
#   211  dockerimage=python:3.4-alpine
#   212  echo $dockerimage
#   213  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH --light $dockerimage
#   214  clear
#   215  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH --light $dockerimage
#   216  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  python:3.4-alpine
#   217  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH --light $dockerimage
#   218  clear
#   219  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH --light $dockerimage
#   220  $?
#   221  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity LOW --light $dockerimage
#   222  $?
#   223  echo $?
#   224  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity LOW --light $dockerimage
#   225  echo $?
#   226  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 1 --severity HIGH --light $dockerimage
#   227  echo $?
#   228  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH --light $dockerimage
#   229  echo $?
#   230  history
#   231  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image --exit-code 0 --severity HIGHE adoptopenjdk/openjdk8:alpine-slim
#   232  clear
#   233  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image --exit-code 0 --severity HIGHE adoptopenjdk/openjdk8:alpine-slim
#   234  echo $?
#   235  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image --exit-code 0 --severity HIGH adoptopenjdk/openjdk8:alpine-slim
#   236  echo $?
#   237  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image --exit-code 0 --severity LOW adoptopenjdk/openjdk8:alpine-slim
#   238  echo $?
#   239  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image --exit-code 1 --severity LOW adoptopenjdk/openjdk8:alpine-slim
#   240  echo $?
#   241  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 1 --severity HIGH python:3.4-alpine
#   242  echo $?
#   243  docker run --rm -v $HOME/Library/Caches:/root/.cache/ aquasec/trivy:0.36.1 image  --exit-code 0 --severity HIGH python:3.4-alpine    adoptopenjdk/openjdk8:alpine-slim

