module Library
  module Identifier
    module Utils

      DEFAULT_SEPARATOR = %r([\s;,/]+)

      extend self; # make everything a module function

      # A good extractor for ISBN/ISSN/OCLC
      # @param str [String]  The raw string that you suspect may contain digitstrings
      # @param separator [Regexp]  A regex used to split into multiple digitstrings
      # @param allow_trailing_x [Boolean]  Whether the number can end in 'X'
      # @param min [Number]  Smallest string allowed
      # @param max [Number]  Largest string allowed
      # @return [Array<String>] extracted digitstrings
      def extract_digitstrings(str,
                               separator: DEFAULT_SEPARATOR,
                               allow_trailing_x: true,
                               min: 0, max: 100)

        scanner = if allow_trailing_x
                    /\d+X?/
                  else
                    /\d+/
                  end
        str.upcase.gsub(/(\d)X(\d)/, '\1 \2').# any internal Xs need to be split on
        split(separator).map {|x| x.gsub(/[^\dX]/, '').scan(scanner)}.flatten
      end


      # Get just the first digitstring
      # @return String
      def extract_digitstring(*args, **kwargs)
        extract_digitstrings(*args, **kwargs).first
      end


    end
  end
end
