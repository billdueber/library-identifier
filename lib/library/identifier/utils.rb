module Library
  module Identifier
    module Utils

      SEPARATOR_CHARS = "\\s;,/"
      ID_CHARS        = "\\dXx"
      STUFFTOKEEP     = SEPARATOR_CHARS + ID_CHARS
      DITCH           = Regexp.new "[^#{STUFFTOKEEP}]+"
      SEPARATORS      = Regexp.new("[#{SEPARATOR_CHARS}]+")


      extend self; # make everything a module function

      def extract_digitstrings(str)
        str.gsub(DITCH, '').
          split(SEPARATORS).
          map { |x| x.gsub(SEPARATORS, '') }.
          compact.
          delete_if { |x| x.empty? or x.nil? }
      end


      def extract_digitstring(str)
        extract_digitstrings(str).first
      end


    end
  end
end
