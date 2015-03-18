FROM phusion/baseimage:latest
MAINTAINER Gwenn Etourneau gwenn.etourneau@gmail.com


RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-updates main universe" >> /etc/apt/sources.list
RUN apt-get -y update && apt-get -y upgrade


#install go-agent
RUN apt-get install -y wget openjdk-7-jre-headless curl unzip git subversion mercurial
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

RUN wget -O /tmp/go-agent.deb http://download.go.cd/gocd-deb/go-agent-14.4.0-1356.deb
RUN dpkg -i /tmp/go-agent.deb
RUN rm /tmp/go-agent.deb

RUN mkdir /etc/service/go-agent
ADD gocd-agent/go-agent-start.sh /etc/service/go-agent/run

#Install CF client

RUN wget -O /tmp/cf-cli.deb http://go-cli.s3-website-us-east-1.amazonaws.com/releases/v6.10.0/cf-cli_amd64.deb
RUN dpkg -i /tmp/cf-cli.deb
RUN rm /tmp/cf-cli.deb



VOLUME ["/var/lib/go-agent"]

CMD ["/sbin/my_init"]

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*