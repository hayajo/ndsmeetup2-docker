FROM centos:centos6

RUN yum -y clean all
RUN yum -y install http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum -y install golang mercurial

ENV GOPATH /usr/local
RUN go get code.google.com/p/go.tools/cmd/present

COPY docker.slide /usr/share/doc/

EXPOSE 3999
CMD cd /usr/share/doc && present -http="0.0.0.0:3999" -play=false
