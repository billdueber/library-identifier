require 'library/identifier/isbn'

# Check validity of checkdigit for the ISBN13 if we have one
class NullISBN < ISBN

  attr_accessor :error
  # Call the superclass and set the error
  def initialize(orig, err)
    super
    @parsed = :null
    @orig = orig
    @error = err
  end

  # Yup. We're null
  def null?
    true
  end

end
