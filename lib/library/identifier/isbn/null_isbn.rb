module Library::Identifier
  class ISBN

    class NullISBN < ISBN

      attr_accessor :error
      # Call the superclass and set the error
      def initialize(orig, err)
        super
        @parsed = :null
        @orig   = orig
        @error  = err
      end

      # Yup. We're null
      def null?
        true
      end

    end
  end

end
