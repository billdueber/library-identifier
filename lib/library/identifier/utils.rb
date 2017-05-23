module Library
  module Identifier

    module BasicExtractor
      extend self # everything is a module function

      def extract_multi(str)
        preprocess(str).
          scan(scanner).
          map {|x| postprocess_result(x)}.
          delete_if {|x| !valid_syntax?(x)}
      end

      alias_method :[], :extract_multi

      def extract_first(str)
        extract_multi(str).first
      end

      def scanner
        /\d+/
      end

      def preprocess(str)
        str
      end

      def postprocess_result(str)
        str
      end

      def valid_syntax?(str)
        true
      end
    end

    class ISSNExtractor

      # ISSNs can't contain a trailing 'X' and are always 8 digits long
      def self.scanner
        /[\d\-]+/
      end

      def self.valid?(str)
        str.size == 8
      end
    end
  end
end

