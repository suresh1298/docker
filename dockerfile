FROM ubuntu:latest
MAINTAINER suresh
WORKDIR /opt
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre
COPY ./java/java.sh /etc/profile.d/java.sh
COPY ./maven/maven.sh /etc/profile.d/maven.sh
RUN apt update --no-install-recommends -y && \
        DEBIAN_FRONTEND="noninteractive" \
        apt-get install tzdata \
        git \
        wget \
        openjdk-8-jdk \
        maven --no-install-recommends -y && \
        git clone https://github.com/vrer2/Sample_Project.git /root/Sample_Project/ && \
	wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.37/bin/apache-tomcat-9.0.37.tar.gz && \
	tar -xvzf apache-tomcat-9.0.37.tar.gz && \
	chmod +x /etc/profile.d/java.sh \
        /etc/profile.d/maven.sh && \
        /bin/bash -c "source /etc/profile.d/java.sh"
COPY ./tomcat/manager.xml /opt/apache-tomcat-9.0.37/conf/Catalina/localhost/manager.xml
COPY ./tomcat/tomcat-users.xml /opt/apache-tomcat-9.0.37/conf/tomcat-users.xml
WORKDIR /root/Sample_Project/
RUN mvn clean install && \
        cp /root/Sample_Project/target/simple-web-app.war /opt/apache-tomcat-9.0.37/webapps/ && \
        rm -rf /var/lib/apt/lists/*
EXPOSE 8080
CMD ["catalina.sh", "run"]
ENTRYPOINT ["/opt/apache-tomcat-9.0.37/bin/catalina.sh", "run"]
