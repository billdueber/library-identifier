require 'library/identifier/utils'
require 'library/identifier/isbn/extractor'
require 'library/identifier/isbn/isbn10'
require 'library/identifier/isbn/isbn13'
require 'library/identifier/null'

module Library::Identifier
  class ISBN < Numeric

    # Split 10/13 stuff into their own modules
    # for organizational purposes, but now
    # I'll just pull them back in
    include ISBNIncludes::ISBN10
    include ISBNIncludes::ISBN13

    # Lazily produce the 10-digit version if given 13
    def isbn10
      @isbn10 ||= derive_10_from_13(@isbn13)
    end

    # Lazily produce the 13 digit version if given 10
    def isbn13
      @isbn13 ||= derive_13_from_10(@isbn10)
    end

    # Check for valid checksum on whichever version we happen to
    # have been given and cache the result.
    def valid?
      @valid ||= !!(isbn10_valid?(@isbn10) or isbn13_valid?(@isbn13))
    end

    # Only the null object is null
    def null?
      false
    end

    # Private initialize method
    # use #from or #all_from
    def initialize(orig, parsed)
      @orig = orig
      case parsed.size
      when 10
        @isbn10 = parsed
      when 13
        @isbn13 = parsed
      else
        raise "ISBN initialize got a parsed string of illegal size #{parsed.size}"
      end
    end

    private_class_method :initialize

  end
end
