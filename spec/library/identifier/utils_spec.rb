require 'minitest-helper'
require 'library/identifier'

describe "Utility methods" do
  U = Library::Identifier::Utils # convenience
  DS = ->(str) { U.extract_digitstring(str)}
  DSS = ->(str) { U.extract_digitstrings(str)}

  describe "digit string extraction" do
    it "leaves a set of digits alone" do
      DS['123456'].must_equal '123456'
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

    it "can handle and upcase an X" do
      DS['  blah blah 12345x'].must_equal '12345X'
    end

    it "fails with an x in the middle of a string" do
      DSS[' 123X45'].must_equal ['123', '45']
    end

    it "is ok with no matches" do
      DS['hello world'].must_be_nil
      DSS['hello world'].must_be_empty
    end


  end


end
