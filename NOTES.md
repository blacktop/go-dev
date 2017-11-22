NOTES
=====

vim-go
------

-	https://hackernoon.com/my-neovim-setup-for-go-7f7b6e805876
-	https://farazdagi.com/2015/vim-as-go-language-ide/

Python
------

-	https://github.com/jarolrod/vim-python-ide

Fonts
-----

Make NERDTree Font

```bash
$ brew install fontforge
$ wget https://github.com/ryanoasis/nerd-fonts/archive/master.zip
$ python3 fonts/ttc2ttf "Menlo Regular.ttc"
$ fontforge -script /path/to/font-patcher "Menlo Regular.ttf" --fontawesome --octicons --pomicons --powerline
```

-	[powerline font](https://github.com/powerline/fonts/blob/master/Meslo%20Slashed/Meslo%20LG%20M%20Regular%20for%20Powerline.ttf)
-	[nerd-fonts](https://github.com/ryanoasis/nerd-fonts/releases/latest)
