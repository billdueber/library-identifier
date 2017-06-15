module Library::Identifier
  module ClassMethods

    # Allow the extending class to set its null class
    attr_accessor :null_class

    # Use a class method to extract the first identifier-like thing
    # and turn it into an appropriate object
    def from(orig)
      processed_pair = self::Extractor.extract_first(orig)
      if parsed.nil?
        self.null_class.new(orig, "No #{self.to_s} found")
      else
        self.new(processed_pair.original, processed_pair.processed)
      end
    end

    # Like from, but returns a (potentially empty) array
    def all_from(orig)
      all = self::Extractor.extract_multi(orig).map do |processed_pair|
        self.factory.from(processed_pair.original, processed_pair.processed)
      end
    end

    alias_method :[], :from
  end
end

