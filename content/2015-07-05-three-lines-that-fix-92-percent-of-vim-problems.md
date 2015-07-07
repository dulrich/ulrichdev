# 2015-07-05 -- Three Lines That Fix 92% of Vim Problems

Most of my early vim problems (after the initial period of looking up hotkeys)
stemmed from the poor (nonexistent) interaction between vim's internal copy
buffer and the system clipboard. Finally instructions pointed at the `"+y"
command sequence, but it turned out ubuntu's default vim is not compiled with
clipboard support. after installing one of the graphical vim packages, which do
have `+clipboard`

`sudo apt-get install vim-gtk`

And remapping the yank and paste commands in vimrc:
```vimscript
	nnoremap y "+y
	nnoremap p "+p
```

everything works much more like it should.

Happy Vimming!

