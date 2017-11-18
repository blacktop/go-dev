FROM golang:alpine

LABEL maintainer "https://github.com/blacktop"

#######################
## INSTALL NEOVIM #####
#######################

RUN apk add --no-cache neovim git ca-certificates

RUN mkdir -p /root/.config/nvim
COPY vimrc /root/.config/nvim/init.vim
RUN ln -s /root/.config/nvim/init.vim /root/.vimrc

# Install vim plugin manager
RUN apk add --no-cache curl \
  && curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
  && rm -rf /tmp/* \
  && apk del --purge curl

# Install vim fonts
RUN apk add --no-cache wget fontconfig \
  && mkdir -p $HOME/.fonts $HOME/.config/fontconfig/conf.d \
  && wget -P $HOME/.fonts                     https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf \
  && wget -P $HOME/.config/fontconfig/conf.d/ https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf \
  && fc-cache -vf $HOME/.fonts/ \
  && echo "set guifont=Droid\\ Sans\\ Mono\\ 10" \
  && rm -rf /tmp/* \
  && apk del --purge wget fontconfig

# Install vim plugins
COPY install-vim-plugins /tmp/install-vim-plugins
RUN chmod +x /tmp/install-vim-plugins && /tmp/install-vim-plugins || true
# RUN nvim -E -u NONE -S ~/.config/nvim/init.vim +qall > /dev/null

#######################
## INSTALL MISC. ######
#######################

RUN apk add --no-cache \
		zsh \
		tmux \
  && rm -rf /tmp/*

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git /root/.oh-my-zsh

COPY zshrc /root/.zshrc

ENTRYPOINT ["zsh"]
