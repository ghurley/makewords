# makewords

Swift implementation of a no longer extant UNIX utility seen in a
[1982 video](https://www.youtube.com/watch?v=tc4ROCJYbm0&t=458s)
produced at Bell Labs. I haven't been able to find any information about the
program so the behavior here is inferred from the brief demo. I've tried to make
it somewhat Unicode aware, a feature that the original certainly didn't have.

Basically, it splits text into "words" (whitespace separated strings) then 
strips off leading and trailing non alpha-numeric chars from each "word" and 
outputs the resulting words, one per line. (e.g. "Don't!" -> Don't).

By default it will downcase each word and has option to fold various unicode
code points (e.g. Café -> cafe).

## Suitability for non-latin languages
The removal of non-alphanumerics is done to remove leading and trailing
punctuation. Implementation wise it's handled by swift's 
`.alphanumerics.inverted` synthetic enum. Alphanumerics includes "all 
characters in Unicode General Categories L*, M*, and N*". Informally, it's 
alphabets, syllabaries, ideographs, and digits. Among other things this means
the tool will work for e.g. Cyrillic but that Emoji will be entirely stripped
(unless surrounded by alphanumerics). This tool will also not work for e.g. 
Chinese but not because of the characters; it doesn't work because words are 
not separated by whitespace. Word segmentation in Chinese is an area of research
and is decidedly non-trivial. 

## Ligature handling in Swift
Swift seems to automatically convert certain ligatures to the component letters.
E.g. `ﬁne` -> `fine` without my specifically asking for the conversion but
*auroræ* does not become *aurorae*. Of course whether or not 
[æ](https://en.wikipedia.org/wiki/%C3%86) is really the same as ae is a matter
of debate.

Note: unicode normalization and folding is complex enough that it is perhaps
best handled by a specialized program such as 
[uconv](https://linux.die.net/man/1/uconv) so I may remove the diacritic 
folding option in the future.

## To run
swift run

## Build/run debug version
swift build
.build/x86_64-apple-macosx/debug/makewords sample.txt

## Build release version
swift build --configuration release