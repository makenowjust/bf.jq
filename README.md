# Brainfuck interpreter written in jq

This is the proof that [jq](http://stedolan.github.io/jq/) is turing-complete!


## description

[Brainfuck](http://en.wikipedia.org/wiki/Brainfuck) is an esoteric programming language having only eight commands, which is turing-complete.
And, jq has a potential to write Brainfuck interpreter, so jq is turing-complete.

## note

This interpreter dosen't support `,` command, because jq is not able to get a character from stdin.

## usage

```console
$ jq -s -R -M -r -f bf.jq
```

## example

```console
# printing `A'
$ echo '++++[>+<++++]>++.' | jq -s -R -M -r -f bf.jq
A
```

## license

MIT-License. See <http://makenowjust.mit-license.org/2014>.

## contributing

If you find bug or make it better, please send [Issue](https://github.com/MakeNowJust/bf.jq/issues) or [Pull Request](https://github.com/MakeNowJust/bf.jq/fork) :laughing:
