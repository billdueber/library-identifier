require 'library/identifier/mixins/class_methods'
require 'library/identifier/issn/extractor'
require 'library/identifier/issn/null_issn'
require 'dry-initializer'

module Library::Identifier

  # Create a factory that returns either
  # an ISBN or an InvalidISBN. We short-circuit
  # looking for a Null object, but if you're using
  # the normal ISBN.from or ISBN.all_from that should
  # never happen.
  class ISSNFactory
    def from(orig, processed)
      return ISSN::NullISSN.new(orig, processed) unless processed
      ISSN.new(orig, processed)
    end
  end

  # Extract and mess with ISBNs, in both their 10-character
  # and 13-digit versions.
  class ISSN

    extend Dry::Initializer::Mixin

    param :original
    param :parsed

    # Define a factory for null, invalid, and normal objects
    FACTORY = ISSNFactory.new
    def self.factory
      FACTORY
    end

    # Pull in the extractor
    extend Library::Identifier::ISSN::Extractor

    # Pull in class methods .from and .all_from
    extend Library::Identifier::ClassMethods

    def to_s
      parsed
    end

  end
end

