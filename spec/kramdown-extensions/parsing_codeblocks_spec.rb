require 'kramdown'
describe "normal fenced codeblock parsing" do
  text = <<__TEXT__
# example document
``` ruby
def valid?
  true
end
```
__TEXT__
  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable') }
  subject(:code_sample) { doc.root.children[1] }

  it "should know the language" do
    code_sample.attr()["class"].should eq "language-ruby"
  end
  it "should know the code text" do
    code_sample.value.should eq "def valid?\n  true\nend\n"
  end
end

describe "file aware codeblock parsing" do
	text = <<__TEXT__
# example document
``` ruby example.rb
def valid?
  true
end
```
__TEXT__

  subject(:doc) { Kramdown::Document.new( text, :input => 'Weavable' ) }
  subject(:code_sample) {doc.root.children[1] }

  it "should know the language" do
    code_sample.attr()["class"].should eq "language-ruby"
  end
  it "should know the code text" do
    code_sample.value.should eq "def valid?\n  true\nend\n"
  end
  it "should know the file name" do
    code_sample.attr()["file"].should eq "example.rb"
  end
  it "should define the root section as *" do
    code_sample.attr()["section"].should eq "*"
  end
end

describe "section aware codeblock parsing" do
	text = <<__TEXT__
# example document
``` ruby example.rb:valid
def valid?
  true
end
```
__TEXT__

  subject(:doc) { Kramdown::Document.new( text, :input => 'Weavable' ) }
  subject(:code_sample) {doc.root.children[1] }

  it "should know the language" do
    code_sample.attr()["class"].should eq "language-ruby"
  end
  it "should know the code text" do
    code_sample.value.should eq "def valid?\n  true\nend\n"
  end
  it "should know the file name" do
    code_sample.attr()["file"].should eq "example.rb"
  end
  it "should define the section as valid" do
    code_sample.attr()["section"].should eq "valid"
  end
end
