FROM ubuntu:xenial

LABEL maintainer "https://github.com/blacktop"

ENV GO_VERSION 1.9.2
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin

RUN buildDeps='ca-certificates wget' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && echo "===> Install Go..." \
  && ARCH="$(dpkg --print-architecture)" \
  && wget --progress=bar:force https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz -O /tmp/go.tar.gz \
  && tar -C /usr/local -xzf /tmp/go.tar.gz \
  && go version \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /go /usr/local/go

RUN apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install -y neovim \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove software-properties-common $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

COPY vimrc ~/.vimrc
RUN ln -s ~/.vimrc ~/.config/nvim/init.vim

RUN buildDeps='ca-certificates curl git' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

ENTRYPOINT ["bash"]
