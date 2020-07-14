FROM tomcat:latest
MAINTAINER suresh
WORKDIR /root/Sample_Project/
#COPY ./target/simple-web-app.war /usr/local/tomcat/webapps
EXPOSE 8080
CMD ["catalina.sh", "run"]
ENTRYPOINT ["catalina.sh", "run"]
