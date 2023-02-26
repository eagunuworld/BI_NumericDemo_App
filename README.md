# kubernetes-devops-security

## Fork and Clone this Repo

## Clone to Desktop and VM

## NodeJS Microservice - Docker Image -
`docker run -p 8787:5000 siddharth67/node-service:v1`

`curl localhost:8787/plusone/99`

## NodeJS Microservice - Kubernetes Deployment -
`kubectl create deploy node-app --image siddharth67/node-service:v1`

`kubectl expose deploy node-app --name node-service --port 5000 --type ClusterIP`

`curl node-service-ip:5000/plusone/99`

## Updated Dockerfile
FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
#################
FROM openjdk:8-jdk-alpine
EXPOSE 8080
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
##############
## opa-docker-security.rego
Get the rego policy from -
https://github.com/gbrindisi/dockerfile-security


FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG user=eagunu
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline && adduser -S ${user} -G pipeline
COPY ${JAR_FILE} /home/${user}/app.jar
USER ${user}
ENTRYPOINT ["java","-jar","/home/${user}/app.jar"]


## Updated Dockerfile
FROM adoptopenjdk/openjdk8:alpine-slim
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java","-jar","/home/k8s-pipeline/app.jar"]

##########update Dockerfile with eagunuworld
FROM  adoptopenjdk/openjdk8:alpine-slim                
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S eagunugp && adduser -S eagunuk8s -G eagunugp
COPY ${JAR_FILE} /home/eagunuk8s/app.jar
USER eagunuk8s
ENTRYPOINT ["java","-jar","/home/eagunuk8s/app.jar"]




