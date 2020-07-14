FROM ubuntu:latest
MAINTAINER suresh
WORKDIR /opt
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
#WORKDIR /opt
COPY ./java.sh /etc/profile.d/java.sh
COPY ./maven.sh /etc/profile.d/maven.sh
COPY ./sonar-scanner.sh /etc/profile.d/sonar-scanner.sh
RUN apt update --no-install-recommends -y && \
        DEBIAN_FRONTEND="noninteractive" \
        apt-get install tzdata \
        git \
        wget \
        unzip \
        openjdk-8-jdk \
        maven --no-install-recommends -y && \
        wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip && \
        unzip sonar-scanner-cli-4.2.0.1873-linux.zip && \
        mv sonar-scanner-4.2.0.1873-linux /opt/sonar-scanner && \
	git clone https://github.com/suresh1298/Sample_Project.git /root/Sample_Project/ && \
	chmod +x /etc/profile.d/java.sh \
        /etc/profile.d/maven.sh && \
        /bin/bash -c "source /etc/profile.d/java.sh" \
        source /etc/profile.d/sonar-scanner.sh
COPY ./settings.xml /etc/maven
COPY ./sonar-scanner.properties /opt/sonar-scanner/conf/sonar-scanner.properties
WORKDIR /root/Sample_Project/
RUN mvn clean install && \
#        cp /root/Sample_Project/target/simple-web-app.war /opt/apache-tomcat-9.0.37/webapps/ && \
        rm -rf /var/lib/apt/lists/*
EXPOSE 8080
CMD ["localhost"]
ENTRYPOINT ["/bin/ping","-c","3"]
