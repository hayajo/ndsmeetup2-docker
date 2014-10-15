FROM centos:centos6

RUN yum -y clean all
RUN yum -y install unzip

RUN curl -LO https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip
RUN unzip 0.4.0_linux_amd64.zip && mv ./consul /usr/local/bin/consul

VOLUME ["/tmp/consul"]

COPY start.sh /usr/local/bin/start
RUN chmod +x /usr/local/bin/start

COPY stop.sh /usr/local/bin/stop
RUN chmod +x /usr/local/bin/stop

ENTRYPOINT ["/usr/local/bin/start"]
