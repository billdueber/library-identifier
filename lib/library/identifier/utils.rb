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
                               valid_lengths: :anylength)

        scanner = if allow_trailing_x
                    /\d+X?/
                  else
                    /\d+/
                  end
        str.upcase.gsub(/(\d)X(\d)/, '\1 \2').# any internal Xs need to be split on
        split(separator).map {|x| x.gsub(/[^\dX]/, '').
          scan(scanner)}.
          flatten.
          keep_if {|x| valid_length(valid_lengths, x.length)}
      end


      # Get just the first digitstring
      # @return String
      def extract_digitstring(*args, **kwargs)
        extract_digitstrings(*args, **kwargs).first
      end


      private
      def valid_length(valid_lengths, length)
        return true if valid_lengths == :anylength or valid_lengths.nil?
        case valid_lengths
        when Array
          valid_lengths.include? length
        when Numeric
          valid_lengths == length
        when Range
          valid_lengths.cover? length
        else
          raise "Don't know what to do with valid_lengths argument of type #{valid_lengths.class}"
        end
      end


    end
  end
end
