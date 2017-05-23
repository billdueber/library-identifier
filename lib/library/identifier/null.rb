module Library::Identifier
  # Simple null object that can carry the original
  # string and an error message around.
  class Null

    attr_reader :orig, :error

    def initialize(orig, error)
      @orig  = orig
      @error = error
    end

    def null?
      true
    end

    def valid?
      false
    end
  end
end
