require 'library/identifier/utils'

module Library::Identifier
  class ISBN
    class Extractor
      include Library::Identifier::BasicExtractor

      def scanner
        /[\d\-]+X?\b/
      end

      def preprocess(str)
        str.upcase
      end

      def postprocess_result(str)
        str.gsub(/-/, '')
      end

      def valid_syntax?(str)
        str.size == 10 or (str.size == 13 and str[-1] =~ /\d/)
      end
    end
  end
end
