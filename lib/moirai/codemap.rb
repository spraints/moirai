
module Moirai
  class CodeMap
    attr_accessor :files
    attr_accessor :directories
    def initialize(document)
      @directories = []
      @files = Hash.new
      @fragments = Hash.new
      find_fragments(document.root)
      build_files()
    end
    def build_files()
      @fragments.keys.each do |file_name|
        @files[file_name] = inflate_section @fragments[file_name]["*"], @fragments[file_name]
      end
    end
    def inflate_section(section, file_sections)
      if section.nil?
	return section
      end
      subsections = section.match(/«(.*?)»/)
      subsections.to_a.drop(1).each do |section_name|
	section.sub!(/«#{section_name}»/, inflate_section(file_sections[section_name], file_sections))
      end
      section
    end
    def add_directory_for(file)
      dir = File.dirname(file)
      if !dir.nil? && dir != "" && ! @directories.member?(dir)
         @directories << dir
      end
    end
    def is_fenced_code?(elem)
      val = elem.type == :fenced_code_file
      val
    end
    def has_file?(elem)
      ! elem.attr()["file"].nil?
    end
    def new_file?(elem)
      ! @fragments.key?( elem.attr()["file"] )
    end
    def find_fragments(elem)
      elem.children.each do |e|
	if is_fenced_code?(e) && has_file?(e)
	  file = e.attr()["file"]
	  section = e.attr()["section"]
          if new_file?(e)
            add_directory_for(file)
            @fragments[file] = Hash.new
          end
	  @fragments[file][section] = e.value
	end
	find_fragments(e)
      end
    end
  end
end
