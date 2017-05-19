module Library
  module Identifier

    module IdentifierExtractor
      extend self # everything is a module function

      def extract_multi(str)
        preprocess(str).
          scan(scanner).
          map {|x| postprocess(x)}.
          delete_if {|x| !valid?(x)}
      end

      alias_method :[], :extract_multi

      def extract_first(str)
        extract_multi(str).first
      end


      def preprocess(str)
        str
      end


      def scanner
        /\d+/
      end


      def postprocess(str)
        str
      end


      def valid?(str)
        true
      end
    end

    class ISBNExtractor
      extend IdentifierExtractor


      def self.scanner
        /[\d\-]+X?/
      end


      def self.preprocess(str)
        str.upcase
      end


      def self.postprocess(str)
        str.gsub(/-/, '')
      end


      def self.valid?(str)
        str.size == 10 or (str.size == 13 and str[-1] =~ /\d/)
      end
    end

    class ISSNExtractor < ISBNExtractor

      def self.scanner
        /[\d\-]+/
      end


      def self.valid?(str)
        str.size == 8
      end
    end
  end
end

