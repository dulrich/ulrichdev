# 2014-08-25 &ndash; When Typing `git add file1` Is Too Much Work

When you first start using git, `git add file1 file2` seems to work ok.
Maybe after a few days that gets annoying, so you try to only make a few relevant changes, then `git add .` will stage everything.
Easy money.
After a while though, even that starts to get cumbersome, especially the first part, so you get `alias gita="git add"`.
Then finally `alias a="git add"`.

So it's short, but not entirely satisfying.
Even with all of this, you're still stuck typing `a .` for the most common case.
As soon as you start aliasing, you also lose git's built-in tab completion (see previous post).
We need a default, while preserving the functionality of the full command.
Thus, `a` would be equivalent to `a .`, but `a file1 file2` would still work as expected.

### Enter defarg, a Default Argument Assignment Function

After some experimentation, having custom conditionals for each alias/function was starting to seem ponderous.
Enter the following bit of shell magic:
```bash
# defarg args which default
defarg() {
	local all=0
	local args=($1)
	local which=$2
	local def=$3
	
	# check for the "all arguments" option
	if [ "$which" == '@' ]; then
		all=1
		which=0
	fi
	
	if [ ${#args[@]} -gt $which ]; then
		if [ all ]; then echo "${args[@]}" # handle passing through all present args
		else echo "${args[$which]}"; fi    # pass back the arg at position "which"
	else
		echo $def # return the default
	fi
}
```
This snippet turns the ugly function for `git add`:
```bash
function a {
	local files
	if [ $# -gt 0 ]; then
		files="$@"
	else
		files='.'
	fi
	git add $files
}
```
into a beautiful one-liner: `a() { git add $(defarg "$*" '@' '.') }` that does exactly the same thing.

### Onward to Option Pass-Through

This is all well and good, but if you want to send some options, you have to type them and the args out, because `defarg` doesn't know about options.
More useful for grep shorcuts than git ones, since they have a higher chance of needing extra/strange options.
Updates about combining flags and defaults will follow.
