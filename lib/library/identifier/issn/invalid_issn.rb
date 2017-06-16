require_relative 'null_issn'

module Library::Identifier
  class ISSN

    # An invalid ISBN has an original string,
    # hence isn't null, but isn't valid? either
    class InvalidISSN < ISSN
     def valid?
        false
      end

      def null?
        false
      end

    end
  end
end

