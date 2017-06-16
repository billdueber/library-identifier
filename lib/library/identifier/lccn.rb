require 'library/identifier/mixins/class_methods'
require 'library/identifier/lccn/extractor'
require 'library/identifier/lccn/null_lccn'
require 'library/identifier/lccn/invalid_lccn'
require 'library/identifier/lccn/validation_and_conversion'
require 'dry-initializer'

module Library::Identifier

  # Create an LCCN, NullLCCN, or InvalidLCCN as appropriate
  class LCCNFactory
    def from(orig, processed)
      return LCCN::NullLCCN.new(orig, processed) unless processed
      lccn = LCCN.new(orig, processed)
      if lccn.valid?
        lccn
      elsif !lccn.valid?
        LCCN::InvalidLCCN.new(orig, processed)
      else
        raise "Not sure what happened: #{orig} / #{processed}"
      end
    end
  end


  # Extract and mess with LCCNs. All this is explained in the
  # lccn/extractor and lccn/validation_and_conversion files; the spec
  # lives at http://www.loc.gov/marc/lccn-namespace.html#syntax
  class LCCN

    extend Dry::Initializer::Mixin


    param :original
    param :parsed

    # Define a factory for null, invalid, and normal objects
    FACTORY = LCCNFactory.new
    def self.factory
      FACTORY
    end

    # Pull in the extractor and validation/normalization
    extend Library::Identifier::LCCN::Extractor
    include Library::Identifier::LCCN::ValidationAndConversion
    extend Library::Identifier::LCCN::ValidationAndConversion

    # Pull in class methods .from and .all_from
    extend Library::Identifier::ClassMethods

    # Not null -- for checking against null object
    def null?
      false
    end

    def to_s
      parsed
    end

    def valid?
      @valid ||= normalized_is_valid?(normalized)
    end

    def normalized
      @normalized ||= normalize
    end


  end
end
