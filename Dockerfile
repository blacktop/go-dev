FROM golang:1.9.2-alpine

LABEL maintainer "https://github.com/blacktop"

#######################
## INSTALL NEOVIM #####
#######################

RUN apk add --no-cache neovim git ca-certificates python3 tzdata bash

RUN mkdir -p /root/.config/nvim
COPY vimrc /root/.config/nvim/init.vim
RUN ln -s /root/.config/nvim/init.vim /root/.vimrc
COPY nvim/snippets /root/.config/nvim/snippets
COPY nvim/spell /root/.config/nvim/spell

# Install vim plugin manager
RUN apk add --no-cache curl \
  && curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && rm -rf /tmp/* \
  && apk del --purge curl

# Install vim fonts (fonts should be installed on host's terminal running docker)
# COPY scripts/install-fonts /tmp/install-fonts
# RUN apk add --no-cache fontconfig
# RUN apk add --no-cache -t .build-deps wget \
#   && echo "===> Installing Fonts..." \
#   && chmod +x /tmp/install-fonts && /tmp/install-fonts \
#   && rm -rf /tmp/* \
#   && apk del --purge .build-deps

# Install vim plugins
RUN apk add --no-cache -t .build-deps build-base python3-dev \
  && pip3 install -U neovim \
  && rm -rf /tmp/* \
  && apk del --purge .build-deps

COPY scripts/install-vim-plugins /tmp/install-vim-plugins
RUN chmod +x /tmp/install-vim-plugins && /tmp/install-vim-plugins || true

#######################
## INSTALL MISC. ######
#######################

RUN apk add --no-cache zsh tmux && rm -rf /tmp/*

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh
RUN git clone https://github.com/tmux-plugins/tpm /root/.tmux/plugins/tpm
RUN git clone https://github.com/tmux-plugins/tmux-cpu /root/.tmux/plugins/tmux-cpu
RUN git clone https://github.com/tmux-plugins/tmux-prefix-highlight /root/.tmux/plugins/tmux-prefix-highlight

COPY zshrc /root/.zshrc
COPY tmux.conf /root/.tmux.conf
COPY tmux.linux.conf /root/.tmux.linux.conf

# RUN go get -d -v github.com/maliceio/engine/...

ENTRYPOINT ["zsh"]
