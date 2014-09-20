Serf + Docker
=============

Serfを使ってDockerコンテナをロードバランサ配下に自動で追加


Prepare
-------

* Build images

        $ cd lb_serf && docker build -t ndsmeetup2/lb_serf .; cd -
        $ cd app_serf && docker build -t ndsmeetup2/app_serf .; cd -


Usage
-----

* Run a load balancer

        $ docker run -itd -p 80:80 -p 9999:9999 --name lb_serf ndsmeetup2/lb_serf

* Run some application servers

        $ for i in $(seq 1 3); do
        docker run -itd --link lb_serf:lb ndsmeetup2/app_serf
        done


Check
-----

* on VM host OS

    - http://VM_IP_ADDRESS/
    - http://VM_IP_ADDRESS:9999/

* on docker host

    - http://localhost:39999/
    - http://localhost:9999/

