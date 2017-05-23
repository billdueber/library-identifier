module Library::Identifier
  class ISBN
    module ISBN10

      def derive_10_from_13(isbn13)
        base = isbn13[3..11]
        base << checkdigit_10(base)
      end

      def checkdigit_10(isbn10str)
        digits     = isbn10str[0..8].each_char.map(&:to_i)
        checkdigit = 0
        (1..9).each do |i|
          checkdigit += digits[i-1] * i
        end
        check = checkdigit % 11
        return 'X' if check == 10
        return check.to_s
      end

      def isbn10_valid?(isbn10)
        isbn10 and (isbn10[-1] == checkdigit_10(isbn10))
      end

    end
  end
end
