module Library::Identifier
  class ISSN

    class NullISSN < ISSN

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
end
