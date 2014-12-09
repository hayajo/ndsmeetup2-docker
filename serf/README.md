# Serf + Docker

Serfを使ってDockerコンテナをロードバランサ配下に自動で追加


## Archtecture

                                                 +------------+
                                          +----> | httpd,serf |
                                          |      | [app_serf] |
                                          |      +------------+
                                          |
                                          |
    +----------+        +--------------+  |      +------------+
    | Internet +------> | haproxy,serf +-------> | httpd,serf |
    +----------+        | [lb_serf]    |  |      | [app_serf] |
                        +--------------+  |      +------------+
                                          |
                                          |
                                          |      +------------+
                                          +----> | httpd,serf |
                                                 | [app_serf] |
                                                 +------------+


## Usage

Build images

    $ (cd lb_serf && docker build -t ndsmeetup2/lb_serf .)
    $ (cd app_serf && docker build -t ndsmeetup2/app_serf .)


Run a load balancer

    $ docker run -it -d -p 80:80 -p 9999:9999 --name lb_serf ndsmeetup2/lb_serf

Run some application servers

    $ for i in $(seq 1 3); do
    for$ docker run -it -d --link lb_serf:lb ndsmeetup2/app_serf
    for$ done


## Check

* on VM host OS

    - http://VM_IP_ADDRESS/
    - http://VM_IP_ADDRESS:9999/

* on docker host

    - http://localhost/
    - http://localhost:9999/

