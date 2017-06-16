require_relative 'null_lccn'

module Library::Identifier
  class LCCN

    # An invalid ISBN has an original string,
    # hence isn't null, but isn't valid? either
    class InvalidLCCN < NullLCCN
      def valid?
        false
      end

      def null?
        false
      end

    end
  end
end

