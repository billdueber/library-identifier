module Library
  module Identifier

    # The role of the extractor is to pull out every string of characters
    # that *looks like* it could be a valid identifier (e.g., ignoring things
    # like checksum validation).
    #
    # This basic version simply pulls out any run of digits
    module BasicExtractor
      extend self # everything is a module function

      def extract_multi(str)
        preprocess(str).
          scan(scanner).
          map {|x| postprocess_result(x)}.
          delete_if {|x| !valid?(x)}
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

      def valid?(str)
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

