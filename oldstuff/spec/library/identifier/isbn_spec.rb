require 'minitest-helper'

describe "ISBN" do
  ISBN = Library::Identifier::ISBN

  describe "extraction" do
    it "throws away garbage" do
      value(ISBN['ISBN: 123-455-4321 (pb.)'].isbn10).must_equal '1234554321'
    end


    it "pulls out some complex stuff" do
      str = '  (hb) 12345-67-890; 44/55 123456789X'
      value(ISBN.all_from(str).map(&:isbn10)).must_equal ['1234567890', '123456789X']
    end

    it "can handle and upcase an X" do
      value(ISBN['  blah blah 123456789x'].isbn10).must_equal '123456789X'
    end

    it "ignores an x in the middle of a digitstring" do
      value(ISBN[' 123X45']).must_be_instance_of Library::Identifier::NullISBN
    end

    it "works correctly with double-x" do
      skip "Not sure how 123456789XX should behave"
      ISBN[' 123456789XX'].must_equal ['123456789X']
    end

    it "requires correct length" do
      str_with_bad_lengths = '  12345678 1234-567890-987 223456-789XX 12345678xx'
      value(ISBN[str_with_bad_lengths].isbn13).must_equal '1234567890987'
    end

  end
end
