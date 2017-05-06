require 'minitest-helper'
require 'library/identifier'

describe "Utility methods" do
  U   = Library::Identifier::Utils # convenience
  DS  = U.method(:extract_digitstring)
  DSS = U.method(:extract_digitstrings)

  describe "digit string extraction" do
    describe "basics" do
      it "leaves a set of digits alone" do
        DS['123456'].must_equal '123456'
      end

      it "is ok with no matches" do
        DS['hello world'].must_be_nil
        DSS['hello world'].must_be_empty
      end

      it "pulls out of the middle of a string" do
        DS['   123   '].must_equal '123'
      end

      it "throws away garbage" do
        DS['ISBN: 123-455-4321 (pb.)'].must_equal '1234554321'
      end

      it "finds multiple" do
        DSS['12345 and 7890'].must_equal ['12345', '7890']
      end

      it "pulls out some complex stuff" do
        DSS['  (hb) 12345-67-890; 44/55'].must_equal ['1234567890', '44', '55']
      end
    end

    describe "Dealing with trailing 'X'" do

      it "can handle and upcase an X" do
        DS['  blah blah 12345x'].must_equal '12345X'
      end

      it "splits with an x in the middle of a digitstring" do
        DSS[' 123X45'].must_equal ['123', '45']
      end

      it "works correctly with double-x" do
        DS[' 1234XX'].must_equal '1234X'
      end

      it "adheres to :allow_trailing_x" do
        DS['1234X'].must_equal '1234X'
        DS['1234X', allow_trailing_x: false].must_equal '1234'
      end

    end

    describe "valid lengths" do

      it "respects a number" do
        DSS['1234 12345 123', valid_lengths: 5].must_equal ['12345']
      end
      it "respects a range" do
        DSS['1234 12345 123', valid_lengths: 4..6].must_equal %w[1234 12345]
      end

      it "respect an array" do
        DSS['1234 12345 123', valid_lengths: [3,5]].must_equal %w[12345 123]
      end
    end

  end


end
