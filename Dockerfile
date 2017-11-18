FROM ubuntu:xenial

RUN apt-get update && apt-get install -y software-properties-common python3-dev python3-pip
RUN add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install -y neovim

ENTRYPOINT ["bash"]
