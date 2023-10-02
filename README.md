# makewords

Swift implementation of a no longer extant UNIX utility seen in a
[1982 video](https://www.youtube.com/watch?v=tc4ROCJYbm0&t=458s)
produced at Bell Labs. Haven't been able to find any information about the
program so the behavior here is inferred from the brief demo.

Basically, it splits text into "words" (whitespace separated strings) then 
strips off leading and trailing non alpha-numeric chars from each "word" and 
outputs the resulting words, one per line. (e.g. "Don't!" -> Don't).

By default it will downcase each word and has option to fold various unicode
code points (e.g. Café -> cafe).

## Suitability for non-latin languages
The removal of non-alphanumerics is done to remove leading and trailing
punctuation. Implementation wise it's handled by swift's 
`.alphanumerics.inverted` enum. This includes "all characters in Unicode 
General Categories L*, M*, and N*". Informally, it's alphabets, syllabaries,
ideographs, and digits so the tool works for e.g. Cyrillic. It doesn't work
for e.g. Chinese but not because the characters; it doesn't work because words
are not separated by whitespace. Word segmentation in Chinese is an area of
research and is decidedly non-trivial.

Note: unicode normalization and folding is complex enough that it is perhaps
best handled by a specialized program such as 
[uconv](https://linux.die.net/man/1/uconv) so I may remove the folding
option in the future.

## To run
swift run

## Build/run debug version
swift build
.build/x86_64-apple-macosx/debug/makewords sample.txt

## Build release version
swift build --configuration release