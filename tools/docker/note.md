# Hello, Docker

https://www.docker.com/

2016/06/26時点で、DockerはLinux上で動くツールなので、MacやWindows上で使いたい場合にはLinuxのVMが必要になる(ただし今は、beta版だがMac上でネイティブにDockerを動かす Docker for Mac もある)。

## Docker Toolbox

https://www.docker.com/products/docker-toolbox

`docker`や`docker-machine`といったコマンドやVirtualBoxなど、MacやWindows上でDockerを動かすのに必要なツール一式をダウンロードするためのインストーラ。

## Docker Machine

https://docs.docker.com/machine/overview/

dockerを実行するホストマシンを管理するためのツール。主にMacやWindows上でDockerを動かすために使う。その場合ローカルにdockerを動かすためのVMを立ち上げて(`default`という名前)、その上にコンテナを作る。`docker-machine`を使えばローカルのMacやWindowsでdockerコマンドを使ってこのVM上にDockerコンテナを構築できる。またそれ以外にも、Linux上で`docker-machine`を使って、リモートにいるDockerのホストを操作する事もできるらしい。

### boot2docker

http://boot2docker.io/

Light weight Linux for Docker

### Docker Quickstart Terminal

これを使うとシェルが立ち上がり、上記の`default`VMを自動で立ち上げてくれる。VirtualBoxのマネージャ画面を見れば`default`が動いているのがわかる。なので、手動で`default`を立ち上げてもdockerが使える。
別にコレを使わなくても、`docker-machine start default`でVMを立ち上げられる。ただ毎回`eval $(docker-machine env default)`が必要っぽい。これはVMへの接続に必要な情報を環境変数として`export`するだけ。


## Kitematic

DockerのGUIツール。使うにはDockerHubへの登録が必要。

## Network

http://deeeet.com/writing/2014/05/11/docker-network/

## Linux以外のマシンでDockerを使う場合の注意

### ホストからDockerへのポートマッピング

例えば`httpd`のDockerをバックグラウンドで走らせても、ホストから`curl http://localhost:8080`という風にはアクセスできない。これは、コンテナにマッピングされるのは実際にそのコンテナをホストしているVMのポートのため。なので`docker-machine ssh default`してVMに入り、その中からなら上記のコマンドで`httpd`のレスポンスを確認できる。つまりローカルのマシンから`httpd`にアクセスするには、ローカルのマシンではなくVMの8080ポートにアクセスする必要がある。VMのIPは`docker-machine ip default`で確認できる。

これだと`cp`コマンドやDockerfile内のADD,COPYもdocker-machine経由だと上手くいかないのではと思ったが、これらは普通に使えた。便利。
