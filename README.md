go-dev
======

[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org) [![Docker Stars](https://img.shields.io/docker/stars/blacktop/go-dev.svg)](https://hub.docker.com/r/blacktop/go-dev/) [![Docker Pulls](https://img.shields.io/docker/pulls/blacktop/go-dev.svg)](https://hub.docker.com/r/blacktop/go-dev/) [![Docker Image](https://img.shields.io/badge/docker%20image-900MB-blue.svg)](https://hub.docker.com/r/blacktop/go-dev/)

> Golang Dev Env Dockerfile

---

Dependencies
------------

-	[golang:alpine](https://hub.docker.com/_/golang/)

Getting Started
---------------

```sh
$ git clone https://github.com/maliceio/malice.git
$ cd engine
$ docker run --init -it --rm -v `pwd`:/go/src/github.com/maliceio/engine blacktop/go-dev
```

Features
--------

-	language: [golang](https://golang.org/dl/) - `1.9.2`  
-	editor: [neovim](https://neovim.io) - `2.2.0`  
-	shell: [zsh](https://github.com/robbyrussell/oh-my-zsh)

### vim

-	Plugin Manager
	-	[vim-plug](https://github.com/junegunn/vim-plug)
-	Plugins
	-	[vim-go](https://github.com/fatih/vim-go)

Colorschemes
------------

Solarized Dark *(default)*: `,bz`

![screenshot1](https://github.com/blacktop/go-dev/raw/master/solarized-dark.png)

PaperColor: `,bp`

![screenshot2](https://github.com/blacktop/go-dev/raw/master/paper-color.png)

Fonts
-----

Want that beautiful **menlo** (default on macOS) font?

> Check out the [NOTES.md](https://github.com/blacktop/go-dev/blob/master/NOTES.md#fonts)

License
-------

MIT Copyright (c) 2017 blacktop
