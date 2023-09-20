# makewords

Swift implementation of a no longer extant UNIX utility seen in a 1982 video
produced at Bell Labs. Haven't been able to find any information about the
program so the behavior here is inferred from the brief demo.

Basically, it splits text on whitespace then strips off leading and trailing
non alpha-numeric chars from each "word" and outputs the resulting words, 
one per line. (e.g. "Don't!" -> Don't).

By default it will downcase each word and has option to fold various unicode
code points (e.g. é -> e).


## To run
swift run

## Build release version
swift build --configuration release