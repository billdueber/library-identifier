require 'library/identifier/mixins/invalid_id'

module Library::Identifier
  class LCCN
    class InvalidLCCN < LCCN
      include Library::Identifier::InvalidID
    end
  end
end

