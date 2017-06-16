require 'library/identifier/mixins/invalid_id'

module Library::Identifier
  class ISBN
    class InvalidISBN < ISBN

      include Library::Identifier::InvalidID

      def isbn10
        nil
      end

      def isbn13
        nil
      end

      def all_versions
        [parsed]
      end
    end
  end
end

