# 2016-01-09 &ndash; Writing Code vs Building Software

Writing code at its best is *actually fun*. You are solving a puzzle, figuring
out the clever trick or nifty algorithm that turns a difficult-sounding problem
into a few elegant lines of code.

This is all well and good, but often that beautiful masterpiece all-too-soon
comes crashing up against the real world. Users submit bad data to your program:

- empty fields because they didn't see it, or don't want to share their birthday
- reversed start and end dates
- negative numbers where they should only be positive
- unexpected characters in input strings (is `*=| Amy |=* <3<3<3` a valid first name? what about a display name?)

After that nice algorithm is coded up, it's time for the battery of defaults,
if-statements, and validation methods that will protect the code from reality. 
In order to write these, you must think about each piece of input that might be
invalid when received, and make a decision about how to proceed. The are options:

- return an error to the user/caller (`missing: 'foo'`, etc)
- clamp the input to a limit (will you tell the caller or just return the limited results?)
- convert the invalid input to a valid default (often 0 for numbers)
- convert missing (optional) values to a sane or expected default

Soon the defaults and input validation code will be as long as the actual
algorithms, and any function call will be similarly guarded for returned errors
and unexpected return values. In fact unguarded function calls will start to
arouse your suspicions as likely harboring a number of yet-undiscovered bugs.

All of this may seem to remove some of the "fun" from coding, which it does. In
place of the thrill of solving puzzles, there comes a calmer satisfaction of the
knowledge that you can build robust software which survives interaction with 
reality.
