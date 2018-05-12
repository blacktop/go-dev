# go-dev

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/go-dev.svg)](https://hub.docker.com/r/blacktop/go-dev/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/go-dev.svg)](https://hub.docker.com/r/blacktop/go-dev/) [![Docker Image](https://img.shields.io/badge/docker%20image-903MB-blue.svg)](https://hub.docker.com/r/blacktop/go-dev/)

> Golang Dev Env Dockerfile

---

## Dependencies

* [golang:alpine](https://hub.docker.com/_/golang/)

## Getting Started

Clone the repo you want to work on and then:

```sh
$ git clone https://github.com/maliceio/engine.git
$ cd engine
$ docker run --init -it --rm -v `pwd`:/go/src/github.com/maliceio/engine blacktop/go-dev
```

Or map your `$GOPATH` inside the container:

```sh
$ alias gvim="docker run --init -it --rm -v $GOPATH:/go -v /etc/localtime:/etc/localtime:ro  blacktop/go-dev"
```

## Features

* language: [golang](https://golang.org/dl/) - `1.10`
* editor: [neovim](https://neovim.io) - `2.2.0`
* shell: [zsh](https://github.com/robbyrussell/oh-my-zsh) _(should I switch to fish?)_

### vim

* Plugin Manager
  * [vim-plug](https://github.com/junegunn/vim-plug)
* Plugins
  * [vim-go](https://github.com/fatih/vim-go)

## Colorschemes

Solarized Dark _(default)_: `,bz`

![screenshot1](https://github.com/blacktop/go-dev/raw/master/solarized-dark.png)

> **NOTE:** I am using the [solarized](https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized) iterm2 theme, if you aren't using it you might see weird results for the default theme. See Issue [#1](https://github.com/blacktop/go-dev/issues/1)

PaperColor: `,bp`

![screenshot2](https://github.com/blacktop/go-dev/raw/master/paper-color.png)

## Fonts

Want that beautiful **menlo** (default on macOS) font?

> Check out the [NOTES.md](https://github.com/blacktop/go-dev/blob/master/NOTES.md#fonts)

## License

MIT Copyright (c) 2017-2018 blacktop
