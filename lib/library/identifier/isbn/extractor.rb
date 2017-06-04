require 'library/identifier/basic_extractor'
require 'library/identifier/isbn'

class Library::Identifier::ISBN
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

      def valid?(str)
        str.size == 10 or (str.size == 13 and str[-1] =~ /\d/)
      end
    end
  end
end
