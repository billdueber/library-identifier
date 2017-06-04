require_relative 'spec_helper'

RSpec.describe "gem structure" do
  it "has a version" do
    expect(Library::Identifier::VERSION).to_not be_nil
  end

end
