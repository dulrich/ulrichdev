# 2014-08-27 &ndash; Marked: Relying on setOptions() is Dangerous

Well, not necessarily dangerous.
But as your project grows you may be left scratching your head.

If you've rendered markdown in nodejs, you probably used marked. 
It's great, and quite easy to use.
But, due to a combination of how the module is setup and how nodejs `require`s modules, `marked.setOptions([...})` may not do what you expect.

Suppose you have a small project/server, and `renderer` has some custom methods for certain elements.
In this case, you call
```coffee
marked.setOptions {
	renderer: renderer
}
```
right after the renderer is defined, and everything is fine.
In a larger project, or working with a team, you may forget that you required marked somewhere, or somebody else may include it as well.

What happens when you (or someone else) calls setOptions with a different custom renderer?

Yep, your renderer is overwritten.
The same applies to any other marked options you are changing.
For maximum safety, and minimal headaches to everyone, it is best to define all your marked options explicitly, and pass them to each render call (or wrap this in a function):

```coffee
mkd = require 'marked'
rdr = new mkd.Renderer

# setup custom renderer methods

mkd_opt = {
	breaks: false
	gfm: true
	pedantic: false
	renderer: rdr
	sanitize: true
	smartLists: true
	smartypants: false
	tables: true
}

# now your settings are used, regardless of how the defaults have been changed
out = mkd content, mkd_opt
```
