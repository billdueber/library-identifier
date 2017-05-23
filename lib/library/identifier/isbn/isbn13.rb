module Library::Identifier
  class ISBN
    module ISBN13
      def isbn13_valid?(isbn13)
        isbn13 and (isbn13[-1] == checkdigit_13(isbn13))
      end

      def derive_13_from_10 isbn10
        base = '978' << isbn10[0..8]
        base << checkdigit_13(base)
      end

      def checkdigit_13(isbn13str)
        checkdigit = 0
        digits     = isbn13str[0..11].each_char.map(&:to_i)
        6.times do
          checkdigit += digits.shift
          checkdigit += digits.shift * 3
        end
        check = 10 - (checkdigit % 10)
        check = 0 if check == 10
        check.to_s
      end

    end
  end
end
