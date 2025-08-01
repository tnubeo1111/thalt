FROM jenkins/jenkins:latest-jdk17

USER root

RUN apt-get update && apt-get install -y lsb-release 

# Install maven
RUN apt-get install -y  maven

# Install Nodejs && npm
RUN apt-get update && apt-get install -y curl \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Install Sonar
RUN SONAR_SCANNER_VERSION=7.1.0.4889 \
  && curl -fsSL -o /tmp/sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VERSION}-linux-x64.zip \
  && unzip /tmp/sonar-scanner.zip -d /opt \
  && rm /tmp/sonar-scanner.zip \
  && ln -s /opt/sonar-scanner-${SONAR_SCANNER_VERSION}-linux/bin/sonar-scanner /usr/local/bin/sonar-scanner

ENV PATH=/opt/sonar-scanner-7.1.0.4889-linux-x64/bin:${PATH}

# Install Trivy
RUN apt-get install -y wget apt-transport-https gnupg lsb-release \
  && wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add - \
  && echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | tee -a /etc/apt/sources.list.d/trivy.list \
  && apt-get update \
  && apt-get install -y trivy

  

# Install Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

RUN git config --global --add safe.directory '*'


