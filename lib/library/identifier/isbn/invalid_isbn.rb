require_relative 'null_isbn'

module Library::Identifier
  class ISBN

    # An invalid ISBN has an original string,
    # hence isn't null, but isn't valid? either
    class InvalidISBN < NullISBN
      def initialize(orig, parsed)
        super(orig, parsed, "Invalid")
      end

      def normalized
        ""
      end

      def to_s
        ""
      end

      def valid?
        false
      end

      def null?
        false
      end

      def all_versions
        [original]
      end
    end
  end
end

