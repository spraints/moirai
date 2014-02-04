# encoding: utf-8
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
Kramdown::Utils::Html::ESCAPE_MAP['«'] = "&laquo;"
Kramdown::Utils::Html::ESCAPE_MAP['»'] = "&raquo;"
Kramdown::Utils::Html::ESCAPE_ALL_RE = Regexp.union(Kramdown::Utils::Html::ESCAPE_ALL_RE, /«|»/)
Kramdown::Utils::Html::ESCAPE_RE_FROM_TYPE[:all] = Kramdown::Utils::Html::ESCAPE_ALL_RE;
