FROM  adoptopenjdk/openjdk8:alpine-slim                
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S eagunugp && adduser -S eagunuk8s -G eagunugp
COPY ${JAR_FILE} /home/eagunuk8s/app.jar
USER eagunuk8s
ENTRYPOINT ["java","-jar","/home/eagunuk8s/app.jar"]