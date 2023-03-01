FROM  adoptopenjdk/openjdk8:alpine-slim                
EXPOSE 8080
ARG JAR_FILE=target/*.jar
RUN addgroup -S demo-gp && adduser -S demo-user -G demo-gp
COPY ${JAR_FILE} /home/demo-user/app.jar
USER demo-user
ENTRYPOINT ["java","-jar","/home/demo-user/app.jar"]