module Library::Identifier
  class ISSN

    class NullISSN < ISSN

      def to_s
        ''
      end

      def null?
        true
      end

    end
  end
end
