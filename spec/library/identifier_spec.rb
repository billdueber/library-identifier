require 'minitest-helper'

describe "Loads cleanly" do
  it "has a version number" do
    refute_nil ::Library::Identifier::VERSION
  end
end
