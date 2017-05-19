require 'minitest-helper'
require 'library/identifier'

describe "Utility methods" do
  ME = Library::Identifier::IdentifierExtractor

  describe "digit string extraction" do
    describe "basics" do
      it "leaves a set of digits alone" do
        value(ME['123456']).must_equal ['123456']
      end

      it "is ok with no matches" do
        value(ME['hello world']).must_be_empty
      end

      it "pulls out of the middle of a string" do
        value(ME['   123   ']).must_equal ['123']
      end


      it "finds multiple" do
        value(ME['12345 and 7890']).must_equal ['12345', '7890']
      end

    end

    describe "ISBN" do
      ISBN = Library::Identifier::ISBNExtractor

      it "throws away garbage" do
        value(ISBN['ISBN: 123-455-4321 (pb.)']).must_equal ['1234554321']
      end


      it "pulls out some complex stuff" do
        value(ISBN['  (hb) 12345-67-890; 44/55 123456789X']).must_equal ['1234567890', '123456789X']
      end

    end

    # describe "Dealing with trailing 'X'" do
    #
    #   it "can handle and upcase an X" do
    #     SE['  blah blah 12345x'].must_equal '12345X'
    #   end
    #
    #   it "splits with an x in the middle of a digitstring" do
    #     ME[' 123X45'].must_equal ['123', '45']
    #   end
    #
    #   it "works correctly with double-x" do
    #     SE[' 1234XX'].must_equal '1234X'
    #   end
    #
    # end

    # describe "valid_lengths" do
    #
    #   it "respects a number" do
    #     DSS['1234 12345 123', valid_lengths: 5].must_equal ['12345']
    #   end
    #   it "respects a range" do
    #     DSS['1234 12345 123', valid_lengths: 4..6].must_equal %w[1234 12345]
    #   end
    #
    #   it "respect an array" do
    #     DSS['1234 12345 123', valid_lengths: [3,5]].must_equal %w[12345 123]
    #   end
    # end

  end


end
