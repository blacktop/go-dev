FROM golang:1.10-alpine

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache ca-certificates git python3 ctags tzdata bash neovim

######################
### SETUP ZSH/TMUX ###
######################

RUN apk add --no-cache zsh tmux && rm -rf /tmp/*

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
RUN git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm
RUN git clone https://github.com/tmux-plugins/tmux-cpu /root/.tmux/plugins/tmux-cpu
RUN git clone https://github.com/tmux-plugins/tmux-prefix-highlight /root/.tmux/plugins/tmux-prefix-highlight

COPY zshrc /root/.zshrc
COPY tmux.conf /root/.tmux.conf
COPY tmux.linux.conf /root/.tmux.linux.conf

####################
### SETUP NEOVIM ###
####################

# Install vim plugin manager
RUN apk add --no-cache curl \
  && curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && rm -rf /tmp/* \
  && apk del --purge curl

# Install vim plugins
RUN apk add --no-cache -t .build-deps build-base python3-dev \
  && pip3 install -U neovim \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

RUN mkdir -p /root/.config/nvim
COPY vimrc /root/.config/nvim/init.vim
RUN ln -s /root/.config/nvim/init.vim /root/.vimrc

COPY nvim/snippets /root/.config/nvim/snippets
COPY nvim/spell /root/.config/nvim/spell

# Go get popular golang libs
RUN echo "===> go get popular golang libs..." \
  && go get -u github.com/nsf/gocode \
  && go get -u github.com/derekparker/delve/cmd/dlv \
  && go get -u github.com/sirupsen/logrus \
  && go get -u github.com/spf13/cobra/cobra \
  && go get -u github.com/golang/dep/cmd/dep \
  && go get -u github.com/fatih/structs \
  && go get -u github.com/gorilla/mux \
  && go get -u github.com/gorilla/handlers \
  && go get -u github.com/parnurzeal/gorequest \
  && go get -u github.com/urfave/cli \
  && go get -u github.com/apex/log/...
# Go get vim-go binaries
RUN echo "===> get vim-go binaries..." \
  && go get github.com/klauspost/asmfmt/cmd/asmfmt \
  && go get github.com/kisielk/errcheck \
  && go get github.com/davidrjenni/reftools/cmd/fillstruct \
  && go get github.com/rogpeppe/godef \
  && go get github.com/zmb3/gogetdoc \
  && go get golang.org/x/tools/cmd/goimports \
  && go get github.com/golang/lint/golint \
  && go get github.com/alecthomas/gometalinter \
  && go get github.com/fatih/gomodifytags \
  && go get golang.org/x/tools/cmd/gorename \
  && go get github.com/jstemmer/gotags \
  && go get golang.org/x/tools/cmd/guru \
  && go get github.com/josharian/impl \
  && go get github.com/dominikh/go-tools/cmd/keyify \
  && go get github.com/fatih/motion

# Install nvim plugins
RUN apk add --no-cache -t .build-deps build-base python3-dev \
  && echo "===> neovim PlugInstall..." \
  && nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1 \
  && echo "===> neovim UpdateRemotePlugins..." \
  && nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1 \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

# Get powerline font just in case (to be installed on the docker host)
RUN apk add --no-cache wget \
  && mkdir /root/powerline \
  && cd /root/powerline \
  && wget https://github.com/powerline/fonts/raw/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf \
  && rm -rf /tmp/* \
  && apk del --purge wget

ENV TERM=screen-256color
# Setup Language Environtment
ENV LANG="C.UTF-8"
ENV LC_COLLATE="C.UTF-8"
ENV LC_CTYPE="C.UTF-8"
ENV LC_MESSAGES="C.UTF-8"
ENV LC_MONETARY="C.UTF-8"
ENV LC_NUMERIC="C.UTF-8"
ENV LC_TIME="C.UTF-8"

# RUN go get -d -v github.com/maliceio/engine/...

ENTRYPOINT ["tmux"]
