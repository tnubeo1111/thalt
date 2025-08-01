# Base image chính thức, tag hiện có và hỗ trợ jdk17
FROM jenkins/jenkins:latest-jdk17 AS base

USER root

ENV SONAR_SCANNER_VERSION=7.1.0.4889

# Cài đặt tất cả một lần, dùng --no-install-recommends, xóa cache sau cài
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      lsb-release \
      maven \
      curl \
      wget \
      gnupg \
      apt-transport-https \
      unzip && \
    \
    # Cài Node.js 18.x và dọn cache npm
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y --no-install-recommends nodejs && \
    npm cache clean --force && \
    \
    # Cài Sonar Scanner
    curl -fsSL -o /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip && \
    unzip /tmp/sonar-scanner.zip -d /opt && \
    rm /tmp/sonar-scanner.zip && \
    ln -s /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin/sonar-scanner /usr/local/bin/sonar-scanner && \
    \
    # Cài Trivy
    wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor > /usr/share/keyrings/trivy-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/trivy-archive-keyring.gpg] https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" > /etc/apt/sources.list.d/trivy.list && \
    apt-get update && apt-get install -y --no-install-recommends trivy && \
    \
    # Cài Docker CLI
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && \
    \
    # Clean apt cache, tmp
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Thêm sonar-scanner vào PATH
ENV PATH=/opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux-x64/bin:${PATH}

# Trả về user jenkins, tránh chạy root trong container
USER jenkins

# Cấu hình git safe directory nếu cần
RUN git config --global --add safe.directory '*'


