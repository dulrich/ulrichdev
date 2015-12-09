# 2014-09-24 &ndash; Make, and Other Secret C/C++ Development Tools

Coming from a web developer background, the C/C++ build process can seem arcane and baffling.
Often apparently important concepts are encountered only in passing comments on the [Stack Overflow](http://www.stackoverflow.com) answers to questions about obscure compiler or linker errors.


*`locate`*: not sure how I missed this before. Very helpful for tracking down where your system put a library.
As long as you know a filename, such as `header.h`, then `locate header.h` will lead you to source.

*`pkg-config`*: used as `pkg-config --cflags <lib>` or `pkg-config --libs <lib>` outputs the compiler or linker flags for <lib> on your system.
This makes building easier for any system with a `pkg-config`, as library include paths will not be broken by different arrangements.
