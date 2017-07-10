require 'library/identifier/mixins/class_methods'
require 'library/identifier/issn/extractor'
require 'library/identifier/issn/null_issn'
require 'library/identifier/issn/invalid_issn'
require 'library/identifier/issn/validation_and_conversion'
require 'dry-initializer'

module Library::Identifier

  # Create an ISSN, NullISSN, or InvalidISSN as appropriate
  class ISSNFactory
    def from(orig, processed)
      return ISSN::NullISSN.new(orig, processed) unless processed
      issn = ISSN.new(orig, processed)
      if issn.valid?
        issn
      elsif !issn.valid?
        ISSN::InvalidISSN.new(orig, processed)
      else
        raise "Not sure what happened: #{orig} / #{processed}"
      end
    end
  end

  # Extract and mess with ISSNs
  class ISSN

    extend Dry::Initializer::Mixin

    param :original
    param :parsed


    # Define a factory for null, invalid, and normal objects
    FACTORY = ISSNFactory.new
    def self.factory
      FACTORY
    end

    # Pull in the extractor and validation/normalization
    extend Library::Identifier::ISSN::Extractor
    include Library::Identifier::ISSN::ValidationAndConversion
    extend Library::Identifier::ISSN::ValidationAndConversion

    # Pull in class methods .from and .all_from
    extend Library::Identifier::ClassMethods

    # The parsed version is already normalized
    def normalized
      parsed
    end

    # Not null -- for checking against null object
    def null?
      false
    end

    def to_s
      parsed
    end

    def valid?
      @valid ||= lastcharacter == checkdigit(parsed)
    end


    private
    def lastcharacter
      parsed[-1]
    end

  end
end
