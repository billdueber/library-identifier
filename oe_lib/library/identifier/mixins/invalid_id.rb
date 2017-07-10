module Library::Identifier::InvalidID

  def valid?
    false
  end

  def null?
    false
  end

  def normalized
    nil
  end

  def to_s
    parsed
  end

end
