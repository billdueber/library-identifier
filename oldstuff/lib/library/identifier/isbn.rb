require 'library/identifier/utils'
require 'library/identifier/isbn/class_methods'
require 'library/identifier/isbn/extractor'

module Library::Identifier
  class ISBN
    class Extractor
      extend Library::Identifier::BasicExtractor
      class << self
        def scanner
          /[\d\-]+X?\b/
        end

        def preprocess(str)
          str.upcase
        end

        def postprocess_result(str)
          str.gsub(/-/, '')
        end

        def valid?(str)
          str.size == 10 or (str.size == 13 and str[-1] =~ /\d/)
        end
      end
    end


    def isbn10
      @isbn10 ||= convert_to_10(@isbn13)
    end

    def isbn13
      @isbn13 ||= convert_to_13(@isbn10)
    end

    # Check for valid checksum on whichever version we happen to
    # have and cache the result.
    def valid?
      @valid ||= !!(isbn10_valid? or isbn13_valid?)
    end

    # Check validity of checkdigit for the ISBN10 if we have one
    def isbn10_valid?
      @isbn10 and (@isbn10[-1] == checkdigit_10(@isbn10))
    end

    # Check validity of checkdigit for the ISBN13 if we have one
    def isbn13_valid?
      @isbn13 and (@isbn13[-1] == checkdigit_13(@isbn13))
    end


    def convert_to_10(isbn13)
      base = isbn13[3..11]
      base << checkdigit_10(base)
    end

    def convert_to_13 isbn10
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

    # See if this is a Null ISBN. If we're here,
    # it never is. Provided as a convenience to
    # mirror API of NullISBN
    def null?
      false
    end

    attr_reader :orig, :parsed

    # Private initialize method
    # use #from or #all_from
    def initialize(orig, parsed)
      @orig = orig
      case parsed.size
      when 10
        @isbn10 = parsed
      when 13
        @isbn13 = parsed
      else
        raise "ISBN initialize got a parsed string of illegal size #{parsed.size}"
      end
    end

    private_class_method :initialize

  end

end
