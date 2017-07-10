require 'dry-initializer'

module Library::Identifier
  class NullID

    extend Dry::Initializer::Mixin

    param :original
    param :parsed

    def to_s
      ''
    end

    def null?
      true
    end

    def normalized
      ""
    end

    def valid?
      false
    end

  end
end
