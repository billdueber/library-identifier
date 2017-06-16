module Library::Identifier
  class LCCN

    class NullLCCN < LCCN

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
