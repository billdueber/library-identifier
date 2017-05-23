require 'minitest-helper'


describe "Utility methods" do
  ME = Library::Identifier::BasicExtractor

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


  end


end
