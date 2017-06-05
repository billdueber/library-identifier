require 'library/identifier/mixins/basic_extractor'

class Library::Identifier::ISBN

  # The ISBN version of the extractor allows any string of
  # digits and dashes, possibly ending in an 'X'
  #
  # The validation then makes sure it's the right length
  # (10, possibly ending with X, or 13 digits)
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
