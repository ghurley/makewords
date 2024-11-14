# makewords

Swift implementation of a no longer extant UNIX command line utility seen in a
[1982 video](https://www.youtube.com/watch?v=tc4ROCJYbm0&t=458s)
produced at Bell Labs. I haven't been able to find any information about the
program so the behavior here is inferred from the brief demo. I've tried to make
it somewhat Unicode aware, a feature that the original certainly didn't have.

Basically, it splits text into "words" (whitespace separated strings) then
strips off various leading and trailing chars from each "word" and
outputs the resulting words, one per line. (e.g. _"Don't!"_ → _Don't_).

By default it will downcase each word and has option to fold various unicode
code points (e.g. Café -> cafe).

It does not attempt to do anything special with HTML input. It does not
attempt to find words that are separated by something other than whitespace,
such as URLs.

## Suitability for non-latin languages

Splitting text on whitespace will not work for languages where words are not
visually separated such as Chinese or (usually) Japanese but many
non-Latin scripts do separate words with spaces and this tool should handle
them well enough.

The stripping of certain leading and trailing characters is more ambiguous.
It's supposed to normalize words in the presence of punctuation: I don't want
a word with a leading quotation mark (for example) to be thought of as
distinct from the same word without the leading punctuation. However, there
are plenty of symbols that - depending on the use case - one _may not wish_ to
strip from words. To get the basic Unicode awareness that this tool has I'm
leaning pretty heavily on Swift's
[`characterSet`](https://developer.apple.com/documentation/foundation/characterset)
structs. For instance, `.alphanumerics.inverted` allows through all alphabets,
syllabaries, ideographs, and digits but strips out emoji, angle brackets, and
things like math & currency symbols. Do you want to identify $1 as distinct
from €1? In contrast `punctuationChars` will retain emojis and currency symbols
but will _not_ remove things like box drawing characters, angle brackets,
the trademark symbol™ or tilde (which unfortunately is the strikethrough symbol
in markdown).

## Ligature handling in Swift

Swift seems to automatically convert certain ligatures to the component letters.
E.g. `ﬁne` -> `fine` without my specifically asking for the conversion but
_auroræ_ does not become _aurorae_. Of course whether or not
[æ](https://en.wikipedia.org/wiki/%C3%86) is really the same as ae is a matter
of debate.

Note: unicode normalization and folding is complex enough that it is perhaps
best handled by a specialized program such as
[uconv](https://linux.die.net/man/1/uconv) so I may remove the diacritic
folding option in the future.

## Isn't there a UNIX one-liner that does this?

Almost. Doug McIlroy’s famous 6 line equivalent to Knuth's 10 page literate
programming example split a file into words with `tr -cs A-Za-z '\n'` (though
a better modern equivalent is `tr -cs "[:alpha:]" "\n"`), which
works by converting every character that _isn't_ alphabetic into a newline.
This deals with leading and trailing punctuation but produces incorrect
results for contractions like "won't". It also removes numbers and fails to
deal with non-alphabetic languages (including Arabic and Hebrew, which
technically employ [abjads](https://en.wikipedia.org/wiki/Abjad)).

## To run

```
swift run
swift run makewords sample.txt
```

## Build/run debug version

```
swift build
.build/x86_64-apple-macosx/debug/makewords sample.txt
- or if you're building on Apple Silicon -
.build/arm64-apple-macosx/debug/makewords sample.txt
```

## Build release version

`swift build --configuration release`
