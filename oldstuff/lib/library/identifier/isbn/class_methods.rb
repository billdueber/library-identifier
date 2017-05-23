require 'library/identifier/isbn'

class Library::Identifier::ISBN
  module ClassMethods
    # Use a class method to extract the first ISBN-like thing
    # and turn it into an ISBN object
    def from(orig)
      parsed = Extractor.extract_first(orig)
      if parsed.nil?
        NullISBN.new(orig, "No ISBN found")
      else
        self.new(orig, parsed)
      end
    end

    # Like from, but returns a (potentially empty) array
    def all_from(orig)
      Extractor.extract_multi(orig).map {|parsed| self.new(orig, parsed)}
    end

    alias_method :[], :from
  end
end

