FROM ubuntu:trusty

RUN apt-get -y update
RUN apt-get -y install nginx nginx-extras lua-nginx-redis

COPY nginx.conf /etc/nginx/nginx.conf

VOLUME ["/var/log/nginx"]
EXPOSE 80

CMD ["/usr/sbin/nginx"]
