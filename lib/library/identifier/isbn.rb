require 'library/identifier/mixins/class_methods'
require 'library/identifier/isbn/validation_and_conversion'
require 'library/identifier/isbn/extractor'
require 'library/identifier/isbn/null_isbn'
require 'library/identifier/isbn/invalid_isbn'

module Library::Identifier

  # Create a factory that returns either
  # an ISBN or an InvalidISBN. We short-circuit
  # looking for a Null object, but if you're using
  # the normal ISBN.from or ISBN.all_from that should
  # never happen.
  class ISBNFactory
    def from(orig, processed)
      return ISBN::NullISBN.new(orig, processed, "Not recognized as ISBN") unless processed
      isbn = ISBN.new(orig, processed)
      if isbn.valid?
        isbn
      elsif !isbn.valid?
        ISBN::InvalidISBN.new(orig, processed)
      else
        raise "Not sure what happened here: #{orig} / #{processed}"
      end
    end
  end

  # Extract and mess with ISBNs, in both their 10-character
  # and 13-digit versions.
  class ISBN

    # Define a factory for null, invalid, and normal objects
    FACTORY = ISBNFactory.new
    def self.factory
      FACTORY
    end

    # Pull in the extractor
    extend Library::Identifier::ISBN::Extractor

    # Pull in class methods .from and .all_from
    extend Library::Identifier::ClassMethods

    # Get the conversion methods, useful as both
    # instance methods and class methods
    extend Library::Identifier::ISBN::ValidationAndConversion
    include Library::Identifier::ISBN::ValidationAndConversion

    # The 10-character version of this ISBN, lazy
    # @return [String, nil] The 10-char ISBN, or nil if that doesn't make sense.
    def isbn10
      @isbn10 ||= convert_to_10(@isbn13)
    end

    # The 13-digit version of this ISBN, lazy
    def isbn13
      @isbn13 ||= convert_to_13(@isbn10)
    end

    # Do we have a valid checksum? Check whichever one we have already set
    def valid?
      @valid ||= (@isbn10 and isbn10_valid?) or (@isbn13 and isbn13_valid?)
    end

    # Default to the 13 digit version for
    # stringification
    def to_s
      isbn13
    end

    # Not null -- for checking against null object
    def null?
      false
    end

    # All held versions of this ISBN
    #   * the original string passed in
    #   * the ISBN10, if one exists
    #   * the ISBN13
    def all_versions
      [original, isbn10, isbn13].uniq.compact
    end

    # The normalized verison is the 13, same as stringified
    def normalized
      isbn13
    end


    attr_accessor :original
    attr_reader :parsed

    # Private initialize method
    # use #from or #all_from
    # or the factory
    def initialize(orig, parsed)
      self.original = orig
      case parsed.size
      when 10
        @isbn10 = parsed
      when 13
        @isbn13 = parsed
      else
        raise "ISBN initialize got a parsed string ('#{parsed}') of illegal size #{parsed.size}"
      end
    end

    protected :initialize

  end

end
