# Moirai

Moirai is a code weaver allowing the weaving of multiple file software projects from a Markdown formatted Literate Programming source.  It is meant to be programming language agnostic.

I've seen a bunch of recent literate programming projects, but they all work by using comments in source files to form the program's corpus.  This lead to a constraint where the structure of the program still determined the structure of the descriptive text.  This didn't seem to be the original intent of literate systems, so I wanted to try a platform where the document came first and the code was used to clarify the intent instead of a code centric literate platform that used words to describe the code.

Much thanks to anyone who's written a literate programming system or auto documenting system.  You've all been an inspiration.

## Installation

Add this line to your application's Gemfile:

    gem 'moirai'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moirai

## Usage

To generate an HTML file explaining your literate source:

	moirai html my_source.markdown

To generate source from your literate source

	moirai code my_source.markdown

To list the files that will be generated

	moirai list my_source.markdow

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Rational

The idea is to take a markdown file with embedded code and weave the code in to code files.  This is mean to be a mostly general weaver/renderer for [Literate Programming](http://en.wikipedia.org/wiki/Literate_programming).

# Components

I'm basing this off of [Kramdown](http://kramdown.rubyforge.org/) (on [GitHub](https://github.com/gettalong/kramdown)) because Kramdown has an intermediat representation I can access for both the document rendering and the 

# Extensions to Markdown

We expect the code to be weaved to be inside of 'fenced code blocks', the code deliminated by 3 back ticks.  The language specifier is usually one word, but we use the following pattern `[language] [path/to/file]:[sectionname|*]` where the section name `*` is the root of the file structure, although if the section has no name, it is assumed the root.  Inside of the fenced code blocks, a section name is surrounded by [Guillemets](http://en.wikipedia.org/wiki/Guillemet) as in the code example below:

	``` ruby somefile.rb:*
	«required gems»
	«download excel sheet»
	«read data to data structure»
	«add historical data to database»
	```

*Note:* Guillemets are written with `option-\` and `option-shift-\` on a mac.

## How it should work

### Theory of Operation - weaver

* The literate document is read in to Kramdown.
* The Weaver crawls the Kramdown representation and collects the fenced code blocks and the following metadata about them, the language, the relative file name, and the section name.
* The Weaver then starts writing files by filling the referenced subsections and writing the text to disk.
* The weaved files will have source mapped line numbers if possible (not yet done)
* The weaved files will have comments stating their section name if source mapping isn't available (not yet done)

### Theory of text rendering - not yet working

* The code sections are anchored based on the file and section name, slugged.
* Code sections are linked to the propper anchors
* Code sections are footered and numbered

### What is left up to the end user?

* Compliation (Bring your own build system)
* project execution (But you can describe a rake file in your corpus)
* round tripping from code to literate files (I'm not sure this is a good idea)

