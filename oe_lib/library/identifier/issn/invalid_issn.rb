require 'library/identifier/mixins/invalid_id'

module Library::Identifier
  class ISSN
    class InvalidISSN < ISSN
      include Library::Identifier::InvalidID
    end
  end
end

