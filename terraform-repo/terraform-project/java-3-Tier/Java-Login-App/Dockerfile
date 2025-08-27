# You can change this base image to anything else
# But make sure to use the correct version of Java

FROM openjdk:17-jdk-alpine

# Simply the artifact path
ARG artifact=target/Java-Login-App-1.0-SNAPSHOT.jar

WORKDIR /app

COPY ${artifact} app.jar

# Expose the port the app runs on
EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]