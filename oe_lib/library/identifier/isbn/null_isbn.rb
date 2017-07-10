require 'library/identifier/mixins/null_id'

module Library::Identifier
  class ISBN

    class NullISBN < NullID
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
