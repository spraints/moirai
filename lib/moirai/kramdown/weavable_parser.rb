require 'kramdown/parser/kramdown'

class Kramdown::Parser::Weavable < Kramdown::Parser::Kramdown
	def initialize(source, options)
		super
		@block_parsers.unshift(:fenced_code_file)
	end

	FENCED_CODE_START = /^[~`]{3,}/

	FENCED_CODE_MATCH = /^(([~`]){3,}) # back ticks or tildes for fencing
	                     \s*?
		             (\w+)? # language (optional)
			     \s*?
			     ((?: \w | \/ | \\)+\.\w+)? # file name (optional. handles directories. requires an extension. no spaces)
                             (\:(?:\*|[\w-]+))? # Section Name (Optional)
			     \n
			     (.*?) # Code
			     ^\1\2*\s*?\n/xm

	def parse_fenced_code_file
	  if @src.check(self.class::FENCED_CODE_MATCH)
	    @src.pos += @src.matched_size
	    el = new_block_el(:fenced_code_file, @src[6])
	    lang = @src[3].to_s.strip
	    el.attr['class'] = "language-#{lang}" unless lang.empty?
	    if (!@src[4].nil?)
	      el.attr['file'] = @src[4]
	      el.attr['section'] = @src[5].nil? ? "*" : @src[5].sub(/^:/, "")
	    end
	    @tree.children << el
	    true
	  else
	    false
	  end
	end
	define_parser(:fenced_code_file, FENCED_CODE_START)
end
