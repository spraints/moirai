require 'moirai'

describe "normal html output" do
  text = <<__TEXT__
# Document

Doing things

__TEXT__

  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable', :auto_ids => false)}
  subject(:html_output) { doc.to_html }
  
  it "output html" do
    html_output.should eq <<__expected__
<h1>Document</h1>

<p>Doing things</p>

__expected__
  end
  it "outputs kramdown" do
	  doc.to_kramdown.should eq <<__expected__
# Document

Doing things

__expected__
  end

end

describe "Code fenced html output" do
  text = <<__TEXT__
~~~ ruby
def valid?
  false
end
~~~
__TEXT__

  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable', :auto_ids => false)}
  subject(:html_output){ doc.to_html }
  it "should output html" do
    html_output.should eq <<__expected__
<pre><code class="language-ruby">def valid?
  false
end
</code></pre>
__expected__
  end
  it "should output kramdown" do
    doc.to_kramdown.should eq <<__expected__
    def valid?
      false
    end
{: .language-ruby}
__expected__
.chomp
  end
end

describe "File Named Code fenced html output" do
  text = <<__TEXT__
~~~ ruby example.rb
def valid?
  false
end
~~~
__TEXT__

  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable', :auto_ids => false)}
  subject(:html_output){ doc.to_html }
  it "should output html" do
    html_output.should eq <<__expected__
<pre file="example.rb" section="*"><code class="language-ruby">def valid?
  false
end
</code></pre>
__expected__
  end
  it "should output kramdown" do
    doc.to_kramdown eq <<__expected__
    def valid?
      false
    end
{: .language-ruby section="*" file="example.rb"}
__expected__
  end
end

describe "File Named Code fenced html output for a section" do
  text = <<__TEXT__
~~~ ruby example.rb:validation
def valid?
  false
end
~~~
__TEXT__

  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable', :auto_ids => false)}
  subject(:html_output){ doc.to_html }
  it "should output" do
    html_output.should eq <<__expected__
<pre file="example.rb" section="validation"><code class="language-ruby">def valid?
  false
end
</code></pre>
__expected__
  end
  it "should output kramdown" do
    doc.to_kramdown eq <<__expected__
    def valid?
      false
    end
{: .language-ruby section="validation" file="example.rb"}
__expected__
  end
end

describe "File named fenced html output for a section referencing another section" do
  text = <<__TEXT__
~~~ ruby example.rb:*
«main»
main()
~~~
__TEXT__

  subject(:doc) { Kramdown::Document.new(text, :input => 'Weavable', :auto_ids => false )}
  subject(:html_output){ doc.to_html }
  it "should output" do
    html_output.should eq <<__expected__
<pre file="example.rb" section="*"><code class="language-ruby">&laquo;main&raquo;
main()
</code></pre>
__expected__
  end
end
