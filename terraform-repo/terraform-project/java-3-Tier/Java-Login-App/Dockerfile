# Stage 1: Build the application using Maven and JDK 8
FROM maven:3.6.3-jdk-8 AS build
WORKDIR /app
COPY . .

RUN mvn clean package -s settings.xml

# Stage 2: Create the final image using Tomcat and JRE 8
FROM tomcat:9.0-jre8-slim
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/dptweb-1.0.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]