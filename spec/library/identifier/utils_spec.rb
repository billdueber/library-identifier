require 'minitest-helper'
require 'library/identifier'

describe "Utility methods" do
  U = Library::Identifier::Utils # convenience

  describe "extract_digitstring" do
    it "leaves a set of digits alone" do
      U.extract_digitstring('123456').must_equal '123456'
    end

    it "pulls out of the middle of a string" do
      U.extract_digitstring('   123   ').must_equal '123'
    end

    it "throws away garbage" do
      U.extract_digitstring('ISBN: 123-455-4321 (pb.)').must_equal '1234554321'
    end
  end

  describe "extract digitstrings" do
    it "finds multiple" do
      U.extract_digitstrings('12345 and 7890').must_equal ['12345', '7890']
    end
  end
end
