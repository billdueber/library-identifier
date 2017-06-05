require 'library/identifier/mixins/class_methods'
require 'library/identifier/isbn/validation_and_conversion'
require 'library/identifier/isbn/extractor'
require 'library/identifier/isbn/null_isbn'

module Library::Identifier

  # Extract and mess with ISBNs, in both their 10-character
  # and 13-digit versions.
  class ISBN

    # Pull in the extractor
    extend Library::Identifier::ISBN::Extractor

    # Pull in class methods .from and .all_from
    extend Library::Identifier::ClassMethods

    # Set the appropriate null class
    self.null_class = Library::Identifier::ISBN::NullISBN


    # Get the conversion methods, useful as both
    # instance methods and class methods
    extend Library::Identifier::ISBN::ValidationAndConversion
    include Library::Identifier::ISBN::ValidationAndConversion

    # The 10-character version of this ISBN
    def isbn10
      @isbn10 ||= convert_to_10(@isbn13)
    end

    # The 13-digit version of this ISBN
    def isbn13
      @isbn13 ||= convert_to_13(@isbn10)
    end

    # Do we have a valid checksum?
    def valid?
      @valid ||= !!(isbn10_valid? or isbn13_valid?)
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

    attr_reader :orig, :parsed

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
