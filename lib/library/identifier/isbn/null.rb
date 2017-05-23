module Library::Identifier
  class ISBN
    # An NULL object for the ISBNs
    class NullISBN < ISBN
      attr_reader :orig, :error
      def initialize(orig, error)
        @orig = orig
        @error = error
      end
      def null?
        true
      end
    end
  end
end
