# macos-tags

`tags` is a command line tool for manipulating OS X's filesystem tags (the colored circles that adorn files / directories in Finder). E.g., these things:

![Image of README.md with Red, Green, and Blue tags](http://i.imgur.com/wIWUULF.png)

Before OS X 10.9 Mavericks, these were called labels, and there are still constants in the API for label numbers and colors, but tags have superseded labels as of Mac OS X ≥ 10.9.


## Install from source

Download, compile with `xcrun` + `swiftc`, and copy the executable file to `/usr/local/bin/tags`:

    git clone https://github.com/chbrown/macos-tags
    cd macos-tags
    make install

The install directory can be changed via the `BINDIR` environment variable (default: `/usr/local/bin`).


## Usage

* `tags --help` prints a short usage message to `stdout`.
* `tags read [file1 ...]` takes _zero or more paths_, and prints each path and its tags (separated by tabs), skipping paths that have no tags.
  - Use `-v` or `--verbose` to print all supplied paths, whether or not they have tags.
  - Since both files and directories can have tags, `tags` makes no distinction between files and directories;
    the printed path will be exactly what you specified as an argument.
* `tags write file [tag1 ...]` takes _exactly one path_ and _zero or more tags_, and replaces that path's tags with those specified.
  - Use `-v` or `--verbose` to print out the specified tags.
  - Omit the tags to clear the files current tags.

Any other arguments will print the error and the short usage message to `stdout`, then exit with `$?=1`.
Non-existent files will cause the program to exit immediately, potentially with a cryptic error message (`NSError#localizedDescription` is not always descriptive, unfortunately).

The ordering that Finder displays will be the reverse of the tags you provide; i.e., the last one will be leftmost and on top.
I'm not sure why this is; I guess it's kind of a stack / Last-In-First-Out model, though there's no API for pushing / popping tags.


## Recipes

Store tags for all paths in the working directory:

    tags read * > /tmp/tags.tsv

Restore them to paths of the same name in the (or perhaps a different) working directory:

    while IFS=$'\t' read -r -a FILETAGS; do
      tags write "${FILETAGS}" "${FILETAGS[@]:1}"
    done < /tmp/tags.tsv


## TODO

* [x] Handle `--help`
* [x] Fail less dramatically when a file doesn't exist
* [x] Allow removing all tags
* [ ] Allow manipulating current tags, instead of only wholesale replacement


## License

Copyright © 2015–2020 Christopher Brown.
[MIT Licensed](https://chbrown.github.io/licenses/MIT/#2015-2020).
