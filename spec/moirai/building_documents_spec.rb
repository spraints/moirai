require 'moirai'

describe "Parse a document with codeblocks that don't belong to documents" do

  document_text = <<__TEXT__
# example document
``` ruby
def valid?
  true
end
```
__TEXT__

  subject(:doc) { Kramdown::Document.new(document_text, :input => 'Weavable') }
  subject(:code_map) { Moirai::CodeMap.new(doc) }

  it "should have no files" do
    code_map.files.length.should == 0
  end
end

describe "parse a document with code blocks that have a file name" do

  document_text = <<__TEXT__
# example document
``` ruby example.rb
def valid?
  true
end
```
~~~ erlang
fib(0) -> 1;
fib(1) -> 1;
fib(n) -> fib(n-1) + fib(n-2).
~~~~
__TEXT__

  subject(:doc) { Kramdown::Document.new(document_text, :input => 'Weavable') }
  subject(:code_map) { Moirai::CodeMap.new(doc) }

  it "should have a file" do
    code_map.files.length.should == 1
  end
  it "should have the file body" do
    code_map.files["example.rb"].should eq "def valid?\n  true\nend\n"
  end
end

describe "parse a document with sections" do
  document_text = <<__TEXT__
# Initialzer

``` ruby src/multipart_example.rb:initializer
def initialize(*args)
  puts args
end
```

# Class Def

``` ruby src/multipart_example.rb
class Example
«initializer»
end
```

# Code file
__TEXT__

  output_text = <<__TEXT__
class Example
def initialize(*args)
  puts args
end

end
__TEXT__

  subject(:doc) { Kramdown::Document.new(document_text, :input => 'Weavable') }
  subject(:code_map) { Moirai::CodeMap.new(doc) }

  it "should have a file" do
    code_map.files.length.should == 1
  end
  it "should understand the directory structure" do
    code_map.directories.should eq ["src"] 
  end
  it "should know about the file" do
    code_map.files.key?("src/multipart_example.rb").should == true
  end
  it "should have the file body" do
    code_map.files["src/multipart_example.rb"].should eq output_text
  end
end
