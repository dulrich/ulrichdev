# Ramblings, some more ornery than others #

A collection of brilliant insights into issues of technology, philosophy, and the Art of Living. Or just things I'd like to remember later.


## 2014-08-11 -- Setting Up Tab-Completion for Bash Aliases in Ubuntu 14.04LTS ##

Some guides have a function that automatically finds aliases, and sets maps them to the completion handlers of the programs they alias ([gist](https://gist.github.com/ckorn/4999102)).
This sometimes works, for example if your aliases are just simple shortcuts:
```bash
alias a="git add"
alias b="git branch"
```

But my most used aliases are actually functions that add sensible defaults if used without arguments, or proxy those they do receive.
These aliases cannot benefit from an automatic completion script, because they do not match the alias="..." pattern.
Thus we are forced to understand a bit more about bash completions in order to manually assign them to these aliases.

You must ensure that the git completion script has been executed prior to assigning completion functions for your aliases.
On Ubuntu 14.04 the relevant script is `/usr/share/bash-completion/completions/git`.
The containing folder has completion scripts for various other programs, which could be aliased the same way.
Running this script creates the completion functions like `__git_complete` and `_git_add`.

Final result (also on github, [here](https://github.com/dulrich/scripts/blob/master/aliases.sh#L115)):
```bash
if [ -f /usr/share/bash-completion/completions/git ]; then
	source /usr/share/bash-completion/completions/git

	__git_complete a _git_add
	__git_complete b _git_checkout
	__git_complete d _git_diff
fi
```


## 2014-08-04 -- Site is Online, Now All it Needs is Everything ##

What's done:
* basic server: coffeescript, express, consolidate, the whole nine yards
* site scaffold in toffee template
* vps setup on digital ocean

What's not:
* separate code from content, post code to github
* reverse-chronological blog post loading
* expanded content everywhere
* pictures