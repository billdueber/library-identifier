module Library::Identifier
  class ISBN

    class NullISBN < ISBN
      attr_accessor :error
      # Call the superclass and set the error
      def initialize(orig, err)
        super
        @parsed = :null
        self.original   = orig
        @error  = err
      end

      # Yup. We're null
      def null?
        true
      end

      # Defaults for a null class
      def valid?
        false
      end

      def isbn10
        nil
      end

      def isbn13
        nil
      end

      def to_s
        ''
      end

      def all_versions
        []
      end

    end
  end

end
