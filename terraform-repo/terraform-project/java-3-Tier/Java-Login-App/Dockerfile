FROM tomcat:9.0-jdk11-openjdk-slim

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war vào thư mục webapps
COPY target/dptweb-1.0.war /usr/local/tomcat/webapps/ROOT.war

# Cổng Tomcat
EXPOSE 8080

# Khởi động Tomcat
CMD ["catalina.sh", "run"]