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
describe "multiple section aware codeblock parsing" do
	text = <<__TEXT__
# example document

``` ruby example_file.rb:valid
def valid?
  true
end
```

# another

``` ruby example_file.rb:invalid
def invalid?
  false
end
```
__TEXT__
	output_html = <<__HTML__
<h1 id="example-document">example document</h1>

<pre file="example_file.rb" section="valid"><code class="language-ruby">def valid?
  true
end
</code></pre>

<h1 id="another">another</h1>

<pre file="example_file.rb" section="invalid"><code class="language-ruby">def invalid?
  false
end
</code></pre>
__HTML__

  subject(:doc) { Kramdown::Document.new( text, :input => 'Weavable' ) }
  subject(:code_sample) {doc.root.children[1] }

  it "has html" do
    doc.to_html.should eq output_html
  end

end
describe "multiple codeblock parsing" do
	text = <<__TEXT__
# example document

~~~ ruby
def valid?
  true
end
~~~

# another

~~~ ruby
def invalid?
  false
end
~~~
__TEXT__
	output_html = <<__HTML__
<h1 id="example-document">example document</h1>

<pre><code class="language-ruby">def valid?
  true
end
</code></pre>

<h1 id="another">another</h1>

<pre><code class="language-ruby">def invalid?
  false
end
</code></pre>
__HTML__

  subject(:doc) { Kramdown::Document.new( text, :input => 'Weavable') }
  subject(:code_sample) {doc.root.children[1] }

  it "has html" do
    doc.to_html.should eq output_html
  end

end
