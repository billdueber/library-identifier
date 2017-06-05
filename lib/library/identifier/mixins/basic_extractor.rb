module Library
  module Identifier

    # The role of the extractor is to pull out every string of characters
    # that *looks like* it could be a valid identifier (e.g., ignoring things
    # like checksum validation).
    #
    # This basic version simply pulls out any run of digits
    module BasicExtractor
      extend self # everything is a module function

      # Pull out all the likely-looking substrings
      # of the given string, based on the scanner
      # and whether they are valid_looking_strings
      #
      # Preprocesses the submitted string, and
      # post-processes anything found.
      def extract_multi(str)
        preprocess(str).
          scan(scanner).
          map {|x| postprocess_result(x)}.
          delete_if {|x| !valid_looking_string?(x)}
      end

      alias_method :[], :extract_multi

      # Get only the first likely-looking string
      def extract_first(str)
        extract_multi(str).first
      end

      # Regex to send to String#scan
      # for likely-identifier extraction
      def scanner
        /\d+/
      end

      # Processing on the submitted string
      # before scanning/extraction
      def preprocess(str)
        str
      end

      # Post-process on any valid_looking_strings
      def postprocess_result(str)
        str
      end

      def valid_looking_string?(str)
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

