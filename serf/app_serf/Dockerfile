FROM centos:centos6

RUN yum -y clean all
RUN yum -y install curl unzip

RUN cd /tmp && curl -Lo serf.zip https://dl.bintray.com/mitchellh/serf/0.6.0_linux_amd64.zip && unzip serf.zip && chmod +x serf && mv serf /usr/bin/serf
EXPOSE 7946

RUN yum -y install httpd
EXPOSE 80

COPY init.sh /usr/local/bin/init
RUN chmod +x /usr/local/bin/init

CMD ["/usr/local/bin/init"]
