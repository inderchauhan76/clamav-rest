# This Dockerfile combines the mkodockx/docker-clamav and lokori/clamav-rest images into one.

FROM mkodockx/docker-clamav:latest

MAINTAINER inder <inderchauhan@hotmail.com>


#RUN yum update -y && yum install -y java-1.8.0-openjdk &&  yum install -y java-1.8.0-openjdk-devel && yum clean all
#RUN apt-get update && apt-get install -y java-1.8.0-openjdk &&  apt-get install -y java-1.8.0-openjdk-devel

RUN echo "deb http://ftp.de.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get update && apt install -t jessie-backports -y openjdk-8-jdk ca-certificates-java

# Set environment variables.

# Get the JAR file
CMD mkdir /var/clamav-rest
COPY target/clamav-rest-1.0.2.jar /var/clamav-rest/

# Define working directory.
WORKDIR /var/clamav-rest/

# Open up the server
EXPOSE 8080 2222

ADD bootstrap.sh /bootstrap2.sh
# RUN chmod 755 /bootstrap2.sh
RUN apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd
COPY sshd_config /etc/ssh/
RUN chmod 755 /bootstrap2.sh
RUN apt-get install -y curl
# RUN chown clamav:clamav -R /var

# RUN chmod 777 -R /var
# USER clamav
ENTRYPOINT ["/bootstrap2.sh"]
