# サンプルウェブアプリ

        $ docker build -t examples/go-webapp .

        $ for h in hoge.example.com fuga.example.com piyo.example.com; do
        for$ docker run -d --name $h -P examples/go-webapp
        for$ done

