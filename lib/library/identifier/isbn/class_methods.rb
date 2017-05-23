module Library::Identifier
  class ISBN
    module ClassMethods

      DEFAULT_ISBN_EXTRACTOR = Extractor.new

      def from(orig, extractor: DEFAULT_ISBN_EXTRACTOR)
        parsed = extractor.extract_first(orig)
        if parsed.nil?
          NullISBN.new(orig, "No ISBN found")
        else
          self.new(orig, parsed)
        end
      end

      def all_from(orig, extractor: DEFAULT_ISBN_EXTRACTOR)
        extractor.extract_multi(orig).map {|parsed| self.new(orig, parsed)}
      end

      alias_method :[], :from
    end
  end
end
