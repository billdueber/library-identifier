class Library::Identifier::ISBN
  # Methods that can be mixed into an instance but
  # are also exposed as class methods so you don't
  # have to instantiate an instance just to
  # compute a checkdigit or something.
  module ValidationAndConversion

    # Check validity of checkdigit for the ISBN10 if we have one
    def isbn10_valid?(isbn10 = self.isbn10)
      isbn10 and (isbn10[-1] == checkdigit_10(isbn10))
    end

    # Check validity of checkdigit for the ISBN13 if we have one
    def isbn13_valid?(isbn13 = self.isbn13)
      isbn13 and convertable_to_isbn10?(isbn13) and (@isbn13[-1] == checkdigit_13(isbn13))
    end

    # Only certain ISBN-13s can be converted to
    # an ISBN10
    def convertable_to_isbn10?(isbn13)
      isbn13 =~ /\A97[89]/
    end

    # Convert a valid 13 digit ISBN to a 10-char
    def convert_to_10(isbn13 = self.isbn13)
      return nil unless convertable_to_isbn10?(isbn13)
      base = isbn13[3..11]
      base << checkdigit_10(base)
    end

    # Convert a valid 10-char ISBN to a 13 digit
    def convert_to_13(isbn10 = self.isbn10)
      base = '978' << isbn10[0..8]
      base << checkdigit_13(base)
    end

    # Compute the correct checkdigit from the
    # first 12 digits of a 13 digit isbn
    def checkdigit_13(isbn13 = self.isbn13)
      checkdigit = 0
      digits     = isbn13[0..11].each_char.map(&:to_i)
      6.times do
        checkdigit += digits.shift
        checkdigit += digits.shift * 3
      end
      check = 10 - (checkdigit % 10)
      check = 0 if check == 10
      check.to_s
    end

    # Compute the correct checkdigit from the
    # first 9 digits of a 10 character isbn
    def checkdigit_10(isbn10 = self.isbn10)
      digits     = isbn10[0..8].each_char.map(&:to_i)
      checkdigit = 0
      (1..9).each do |i|
        checkdigit += digits[i-1] * i
      end
      check = checkdigit % 11
      check = 'X' if check == 10
      check.to_s
    end
  end
end
