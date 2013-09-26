module Kramdown
  module Converter
    class Html
      def convert_fenced_code_file(el, indent)
        self.convert_codeblock(el, indent)
      end
    end
    class Kramdown
      def convert_fenced_code_file(el, indent)
        self.convert_codeblock(el, indent)
      end
    end
  end
end
