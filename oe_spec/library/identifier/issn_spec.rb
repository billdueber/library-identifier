require_relative '../../spec_helper'
require 'yaml'

RSpec.describe "ISSN" do
  it "Loads up" do
    expect(Library::Identifier::ISSN).to be_a Class
  end

  describe "Extraction" do
    def extracted_strings(str)
      Library::Identifier::ISSN::Extractor.extract_multi(str).map(&:processed)
    end

    def extracted_string(str)
      extracted_strings(str).first
    end

    YAML.load_file(File.join(SPECDATADIR, 'issn.yaml'))['extract_single'].each do |msg, str, exp|
      it "single_string: #{msg}" do
        expect(extracted_string(str)).to eq(exp)
      end
    end

    YAML.load_file(File.join(SPECDATADIR, 'issn.yaml'))['extract_multiple'].each do |msg, str, exp|
      it "multiple strings: #{msg}" do
        expect(extracted_strings(str)).to eq(exp)
      end
    end
  end

  describe "Validation" do
    ISSN = Library::Identifier::ISSN

    it "validates with a digit" do
      expect(ISSN.from('0973-4538').valid?).to be_truthy
    end

    it "sees bad checkdigit" do
      expect(ISSN.from('0973-4530').valid?).to be_falsey
    end

    it "validates with an X" do
      expect(ISSN.from('2230-844X').valid?).to be_truthy
    end
  end

  describe "normalization" do
    it 'normalizes the same as the parsed version for valid' do
      issn  = ISSN.from('0973-4538')
      expect(issn.normalized).to eq(issn.parsed)
    end

    it "normalizes to nil for invalid" do
      expect(ISSN.from('0973-4530').normalized).to be_nil
    end
  end

end
