# 2015-05-02 - Programming: A Spatial Activity

The mathematic aspects of programming have been well documented and researched
in the functional programming world (lambda calculus).

What is often less obvious is the spatial nature of most programming activities.
OOP is based on representing nebulous concepts as concrete objects. Whitespace 
sensitive languages make explicit the connection between code's form and its 
function. But most languages have block delimiters, and yet indentation is still
used by nearly all programmers. By indenting code it has structure. This is not
for aesthetics and not for the computer, but for the programmer's ability to 
know many things about large volumes of code, without reading them in detail.

Optional indentation has its costs as well. When the meaning of indentation and 
the code itself differ, programmers are likely to acquire false ideas about the
program. Strange bugs may arise or be difficult to pinpoint when incorrect code
is masked by correct structure.

A class of bugs in c-like languages are expanded-one-liners, which arise from 
using the alternate syntax of conditionals or loops with no braces if they 
contain only one expression. This can be ok if everything fits on one line. To 
add additional expressions the original code must be indented, and the developer
will most likely remember to add the braces while doing this adjustment. It is 
still safer to always but braces around conditionals and loops. This makes the 
default safe for expansion, whether that is with new code or with debugging 
statements. 

```c
/* dangerous, extra expressions at the level of bar() will be unconditional */
if (foo)
	bar();

/* less dangerous, bar() will have to be moved to add expressions */
if (foo) bar();

/* best practice, saves errors and simplifies adding debug statements */
if (foo) {
	bar();
}
```

After coding this way for some time, you should start to forget that your 
language allows the dangerous version. At least until you run up against just
such a problem in someone else's code. But that's an issue for another post.
