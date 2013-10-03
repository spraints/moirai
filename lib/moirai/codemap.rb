
module Moirai
  class CodeMap
    attr_accessor :files
    def initialize(document)
      @files = Hash.new
      @fragments = Hash.new
      find_fragments(document.root)
      build_files()
    end
    def build_files()
      @fragments.keys.each do |file_name|
        @files[file_name] = @fragments[file_name]["*"]
      end
    end
    def find_fragments(elem)
      elem.children.each do |e|
	if e.type == :fenced_code_file && ( !e.attr()["file"].nil? )
          @fragments[e.attr()["file"]] = { e.attr()["section"] =>  e.value}
	end
	find_fragments(e)
      end
    end
  end
end
