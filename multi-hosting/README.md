# Hosting multiple sites

Dockerを使ったマルチサイトホスティングの例


## Archtecture


    +----------+              +-------------+           +------------+         +------------------+
    | Internet +------------> | nginx       +----+----> | wordpress  +-------> | mysql            |
    +----------+              | [dproxy]    |    |      | [hoge.com] |         | [hoge.com_mysql] |
                              +-----+-------+    |      +------------+         +------------------+
                                    |            |
                                    |            |
                              +-----v-------+    |      +------------+         +------------------+
                              | redis       |    +----> | wordpress  +-------> | mysql            |
                              | [upstreams] |    |      | [fuga.com] |         | [fuga.com_mysql] |
                              +-----^-------+    |      +------------+         +------------------+
                                    |            |
                                    |            |
                              +-----+-------+    |      +------------+         +------------------+
                              | linked      |    +----> | wordpress  +-------> | mysql            |
                              | [linked]    |           | [piyo.com] |         | [piyo.com_mysql] |
                              +-----+-------+           +------------+         +------------------+
                                    |
                                    |
                              +-----v-------+
                              | Docker      |
                              | Remote API  |
                              +-------------+


## Usage

check running docker daemon with `-H tcp://<DOCKER_HOST>:2375`.

if running docker without the option, edit `DOCKER_OPTS` in `/etc/default/docker`.

    DOCKER_OPTS="-H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock"

and restart docker daemon.

    $ sudo service docker restart

Prepare upstream

    $ docker run -d --name=upstreams redis

Run linked

    $ (cd linked && docker build -t ndsmeetup2/linked .)
    $ docker run \
    -d \
    --name=linked \
    --link upstreams:redis \
    -e DOCKER_URL=tcp://$(ip a show docker0 | ag -w inet | sed -e 's/\s\+/ /g' | cut -d ' ' -f3 | sed -e 's|/[0-9]\+$||'):2375 \
    ndsmeetup2/linked

Run dproxy

    $ (cd dproxy && docker build -t ndsmeetup2/dproxy .)
    $ docker run \
    -d \
    --name dproxy \
    --link upstreams:redis \
    -p 8080:80 \
    ndsmeetup2/dproxy

Hosts containers

    $ for h in hoge.com fuga.com piyo.com; do
    for$ docker run -d --name ${h}_mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress mysql
    for$ sleep 5
    for$ docker run -d --name $h --link ${h}_mysql:mysql -e WORDPRESS_DB_PASSWORD=root -P wordpress
    for$ done

Edit /etc/hosts

    $ sudo sh -c 'echo "127.0.0.1 hoge.com fuga.com piyo.com" >> /etc/hosts'

Access with web browser

    $ open http://hoge.com
    $ open http://fuga.com
    $ open http://piyo.com

