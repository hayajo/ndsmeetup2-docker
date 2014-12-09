# Using Weave to connect containers on other hosts

異なるホストのコンテナ間通信

* [zettio/weave](https://github.com/zettio/weave)
* [Weaveを試してみた](http://www.slideshare.net/jacopen/weave-40871981)


## Archtecture

     +-------------------+        +-------------------+
     | +---------------+ |        | +---------------+ |
     | | weave         | <--------> | weave         | |
     | +---------------+ |        | +---------------+ |
     | +---------------+ |        | +---------------+ |
     | | wordpress     | |        | | mysql         | |
     | | 10.0.1.1/24   | |        | | 10.0.1.2/24   | |
     | +---------------+ |        | +---------------+ |
     |                   |        |                   |
     |  Docker Host      |        |  Docker Host      |
     |  192.168.33.10/24 |        |  192.168.33.20/24 |
     +-------------------+        +-------------------+


## Usage

    $ vagrant up --no-parallel
    $ open http://localhost:8080

