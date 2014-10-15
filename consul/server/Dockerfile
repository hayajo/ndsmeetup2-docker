FROM centos:centos6

RUN yum -y clean all
RUN yum -y install unzip

RUN curl -LO https://dl.bintray.com/mitchellh/consul/0.4.0_linux_amd64.zip
RUN unzip 0.4.0_linux_amd64.zip && mv ./consul /usr/local/bin/consul

RUN curl -LO https://dl.bintray.com/mitchellh/consul/0.4.0_web_ui.zip
RUN mkdir /opt/consul
RUN unzip 0.4.0_web_ui.zip && mv ./dist /opt/consul/dist

EXPOSE 8500 8600
VOLUME ["/tmp/consul"]

ENTRYPOINT ["consul", "agent", "-server", "-data-dir=/tmp/consul", "-ui-dir=/opt/consul/dist", "-client=0.0.0.0" ]
