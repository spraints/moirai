Moirai

Moirai is a code weaver allowing the weaving of multiple file software projects from a Markdown formatted Literate Programming source.  It is meant to be programming language agnostic.

## Installation

Add this line to your application's Gemfile:

    gem 'moirai'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moirai

## Usage

__Warning!__ the command line tools are not currently existant.

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

We expect the code to be weaved to be inside of 'fenced code blocks', the code deliminated by 3 back ticks.  The language specifier is usually one word, but we use the following pattern `[language] [path/to/file]:[sectionname|*]` where the section name `*` is the root of the file structure.  Inside of the fenced code blocks, a section name is surrounded by [Guillemets](http://en.wikipedia.org/wiki/Guillemet) as in the code example below:

```ruby somefile.rb:*
«required gems»
«download excel sheet»
«read data to data structure»
«add historical data to database»
```

*Note:* French quotes are written with `option-\` and `option-shift-\` on a mac.

# Theory of Operation - weaver

* The literate document is read in to Kramdown.
* The Weaver crawls the Kramdown representation and collects the fenced code blocks and the following metadata about them, the language, the relative file name, and the section name.
* The Weaver then starts writing files by filling the referenced subsections and writing the text to disk.
* The weaved files will have source mapped line numbers if possible
* The weaved files will have comments stating their section name if source mapping isn't available

# Theory of text rendering

* The code sections are anchored based on the file and section name, slugged.
* Code sections are linked to the propper anchors
* Code sections are footered and numbered

# What is left up to the end user?

* Compliation
* project execution
* round tripping from code to literate files

