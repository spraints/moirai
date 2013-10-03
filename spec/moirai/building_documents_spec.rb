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
