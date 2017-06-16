class Library::Identifier::ISSN
  # Methods that can be mixed into an instance but
  # are also exposed as class methods so you don't
  # have to instantiate an instance just to
  # compute a checkdigit or something.
  module ValidationAndConversion

    def checkdigit(str = self.parsed)
      first_seven_digits = str[0..6].split(//).map {|i| i.to_i}
      checksum = 0
      first_seven_digits.each_with_index do |digit, i|
        checksum += digit * (8 - i)
      end
      checkdigitchar_from_checksum(checksum)
    end

    def checkdigitchar_from_checksum(checksum)
      modded = checksum % 11
      return '0' if modded == 0
      reduced = 11 - modded
      if reduced == 10
        'X'
      else
        reduced.to_s
      end
    end
  end
end

