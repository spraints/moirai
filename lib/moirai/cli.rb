require "thor"
module Moirai
  class CLI < Thor
    desc "list [literate source]", "describe the files to be created"
    def list(source)
      read_initial_document source

      map = Moirai::CodeMap.new(@doc)
      puts map.files.keys
    end

    desc "code [literate source]", "generates the contained code files"
    def code(source)
      read_initial_document source

      map = Moirai::CodeMap.new(@doc)
      map.directories.each do |directory|
	if not Dir.exist? directory
          Dir.mkdir directory
	end
      end

      map.files.each_pair do |file_name, body|
        File.open(file_name, "wb") do |f|
          f.write(body)
	end
      end
    end

    desc "html [literate source]", "converts the file to a publishable html file"
    def html(source)
      read_initial_document source

      File.open(File.basename(source, File.extname(source)) + ".html", "wb") do |f|
          f.write(@doc.to_html)
      end
    end

    desc "both [literate source]", "outputs html and code files"
    def both(source)
      invoke :code
      invoke :html
    end

    no_commands do
      def read_initial_document(source)
        if @doc
	  return
	end

        document_text = ""
        File.open(source, "rb", :encoding => 'UTF-8') do |f|
  	document_text = f.read
        end
        @doc = Kramdown::Document.new(document_text, :input => 'Weavable')
      end
    end
  end
end
