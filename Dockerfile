FROM ubuntu:xenial

LABEL maintainer "https://github.com/blacktop"

#######################
## INSTALL GOLANG #####
#######################

ENV GO_VERSION 1.9.2

RUN buildDeps='ca-certificates wget' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && echo "===> Install Go..." \
  && ARCH="$(dpkg --print-architecture)" \
  && wget --progress=bar:force https://storage.googleapis.com/golang/go$GO_VERSION.linux-$ARCH.tar.gz -O /tmp/go.tar.gz \
  && tar -C /usr/local -xzf /tmp/go.tar.gz \
  && export PATH="/usr/local/go/bin:$PATH" \
  && go version \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

COPY go-wrapper /usr/local/bin/

#######################
## INSTALL NEOVIM #####
#######################

RUN apt-get update && apt-get install -y software-properties-common \
  && add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install -y neovim \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove software-properties-common \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

RUN mkdir -p ~/.config/nvim
COPY vimrc ~/.config/nvim/init.vim
RUN ln -s ~/.config/nvim/init.vim ~/.vimrc

# Install vim plugin manager
RUN buildDeps='ca-certificates curl' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

# Install vim fonts
RUN buildDeps='ca-certificates wget fontconfig' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && mkdir -p $HOME/.fonts $HOME/.config/fontconfig/conf.d \
  && wget -P $HOME/.fonts                     https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf \
  && wget -P $HOME/.config/fontconfig/conf.d/ https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf \
  && fc-cache -vf $HOME/.fonts/ \
  && echo "set guifont=Droid\\ Sans\\ Mono\\ 10" \
  && echo "===> Clean up unnecessary files..." \
  && apt-get purge -y --auto-remove $buildDeps $(apt-mark showauto) \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/*

# Install vim plugins
COPY install-vim-plugins /tmp/install-vim-plugins
# RUN chmod +x /tmp/install-vim-plugins && /tmp/install-vim-plugins
RUN nvim -E -u NONE -S ~/.vimrc +qall

#######################
## INSTALL MISC. ######
#######################

# gcc for cgo
RUN apt-get update && apt-get install -y --no-install-recommends \
		g++ \
		gcc \
		libc6-dev \
    git \
		make \
		pkg-config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

# zsh & tmux
RUN apt-get update && apt-get install -y --no-install-recommends \
		zsh \
		tmux \
		tmuxinator \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
COPY zshrc ~/.zshrc

ENTRYPOINT ["zsh"]
