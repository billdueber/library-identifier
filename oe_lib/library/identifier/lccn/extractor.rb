require 'library/identifier/mixins/basic_extractor'

class Library::Identifier::LCCN

  # Extract LCCNs from the given text
  #
  # LCCNs are a bit of a beast, given that they can have basically
  # any number/letter in them as well as slashes and dashes and spaces.
  # All we can do is accept any runs of those characters and
  # hope for the best.
  #
  # One practical implication is that we can't split on any of that
  # stuff, so multiple numbers in the same string will need to be
  # separated by otherwise-illegal punctuation (e.g., commas)
  #
  # On wrinkle: sometime folks will put the URI prefix on it
  # (for RDF triples, for example). We'll take that out
  # during pre-processing
  module Extractor
    extend Library::Identifier::BasicExtractor

    URI_PREFIX = 'http://lccn.loc.gov/'
    class << self
      def scanner
        %r([\p{L}\d/\- ]+)
      end

      # to preprocess, lowercase it and remove the URL
      # prefix if present, replacing it with a comma
      # in case multiple LCCNs are present
      def preprocess(str)
        str.downcase.gsub(URI_PREFIX, ',')
      end

      # The rules state that if a slash is present, we can throw
      # it away as well as everything after it.
      # And either way, ditch the spaces
      def postprocess_result(str)
        str.gsub(/\s/, '').gsub(%r(/.*\Z), '')
      end

      # There's no good way to know if we got a legal-looking
      # string -- just have to run the piss-poor validation on it
      # and hope for the best. We have to presume, in other words,
      # that users are doing their best to only send LCCNs.
      def valid_looking_string?(str)
        str =~ /\d/
      end
    end
  end
end
