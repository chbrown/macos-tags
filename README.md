# osx-tags

Command line tool for manipulating file OS X's file tags (the colored circles that adorn files / directories in Finder). E.g., these things:

![Image of README.md with Red, Green, and Blue tags](http://i.imgur.com/wIWUULF.png)

Before OS X 10.9 Mavericks, these were called labels, and there are still constants in the API for label numbers and colors, but tags have superseded labels as of OS X >= 10.9.

## Install and run

It's a Swift program and interpreted, not compiled. Install like so:

    wget https://raw.githubusercontent.com/chbrown/osx-tags/master/tags -O /usr/local/bin/tags
    chmod +x /usr/local/bin/tags

There are three possible invocations:

1. `tags`, with no arguments, prints the usage message.
2. `tags README.md`, with a single argument—the filename—prints the file's current tags, tab-separated, on a single line.
3. `tags README.md Blue Green Red`, with multiple arguments—the filename and a list of tag names—sets the file's tags to just those that are named, overwriting whatever tags it might have had before.

You can use a tag name like `None`, to remove all tag colors, since there is no default color for a tag called "None".

The ordering that Finder displays will be the reverse of the tags you provide; i.e., the last one will be leftmost and on top.
I'm not sure why this is; I guess it's kind of a stack / Last-In-First-Out model, though there's no API for pushing / popping tags.


### TODO

* Handle `--help`
* Fail less dramatically when the file doesn't exist
* Allow removing all tags
* Allow manipulating current tags


## License

Copyright 2015 Christopher Brown. [MIT Licensed](http://chbrown.github.io/licenses/MIT/#2015).
