require 'library/identifier/mixins/basic_extractor'

class Library::Identifier::ISSN

  # ISSNs are just chars, 7 digits followed by a digit
  # or an X
  module Extractor
    extend Library::Identifier::BasicExtractor
    class << self
      def scanner
        /[\d\-]+X?\b/
      end

      def preprocess(str)
        str.upcase
      end

      def postprocess_result(str)
        str.gsub(/-/, '')
      end

      def valid_looking_string?(str)
        str.size == 8
      end
    end
  end
end
