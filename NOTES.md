NOTES  
=====

Python
------

- https://github.com/jarolrod/vim-python-ide

Fonts  
-----

Make NERDTree Font  

```bash  
$ brew install fontforge
$ wget https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/font-patcher
$ python3 fonts/ttc2ttf "Menlo Regular.ttc"
$ fontforge -script font-patcher "Menlo Regular.ttf" --fontawesome --octicons --pomicons --powerline
```
