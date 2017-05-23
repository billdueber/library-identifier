require 'library/identifier/utils'
require 'library/identifier/isbn/extractor'
require 'library/identifier/isbn/isbn10'
require 'library/identifier/isbn/isbn13'
require 'library/identifier/isbn/null'

module Library::Identifier
  class ISBN

    # Split 10/13 stuff into their own modules
    # for organizational purposes, but now
    # I'll just pull them back in
    include ISBN10
    include ISBN13

    DEFAULT_ISBN_EXTRACTOR = Extractor.new

    # Return the first viable ISBN from the passsed
    # string using the given extractor
    def self.from(orig, extractor: DEFAULT_ISBN_EXTRACTOR)
      if parsed = extractor.extract_first(orig)
        self.new(orig, parsed)
      else
        NullISBN.new(orig, "No ISBN found")
      end
    end

    # Return an array of all viable ISBN from the passsed
    # string using the given extractor
    def self.all_from(orig, extractor: DEFAULT_ISBN_EXTRACTOR)
      extractor.extract_multi(orig).map {|parsed| self.new(orig, parsed)}
    end

    class << self
      # Convenience: ISBN[my_raw_str]
      alias_method :[], :from
    end

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
