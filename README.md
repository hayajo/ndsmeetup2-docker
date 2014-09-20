はじめてのDocker
================

[NDS in Niigata #2 - connpass](http://nds-meetup.connpass.com/event/8049/)


Usage
-----

    $ docker build -t ndsmeetup2/docker .
    $ docker run -d -p 3999:3999 ndsmeetup2/docker

* on VM host OS

    Access to http://<VM_IP_ADDRESS>:3999/docker.slide

* on docker host

    Access to http://localhost:39999/docker.slide

