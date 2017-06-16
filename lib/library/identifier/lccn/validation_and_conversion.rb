class Library::Identifier::LCCN
  module ValidationAndConversion

    DASH_SPLIT = %r(\A(.*?)-(.*)\Z)
    NON_DIGIT  = %r(\D)
    ALLDIGITS  = %r(\A\d+\Z)
    ALLALPHAS  = %r(\A[a-z]+\Z)

    # Normalize based on data at http://www.loc.gov/marc/lccn-namespace.html#syntax
    # @param [String] processed The processed LCCN to normalize (from the extractor)
    # @return [String, nil] the normalized LCCN, or nil if it looks malformed
    def normalize(parsed = self.parsed)
      # If there's a dash, split on it and normalize from there
      m = DASH_SPLIT.match(parsed)
      if m
        normalize_string_with_dash(m[1], m[2])
      else
        parsed
      end
    end
  end

  def all_digits(str)
    !(str =~ /\D/)
  end

  # Join the pre/post dash parts after processing.
  # Post-dash must be all digits, padded with 0s to six chars
  def normalize_string_with_dash(predash, postdash)
    return nil unless all_digits(postdash)
    "%s%06d" % [predash, postdash.to_i]
  end

  # The rules for validity according to http://www.loc.gov/marc/lccn-namespace.html#syntax:
  #
  # 1. A normalized LCCN is a character string eight to twelve characters in length.
  #    (For purposes of this description characters are ordered from left to
  #    right -- "first" means "leftmost".)
  # 2. The rightmost eight characters are always digits.
  # 3. If the length is 9, then the first character must be alphabetic.
  # 4. If the length is 10, then the first two characters must be either both
  #    digits or both alphabetic.
  # 5. If the length is 11, then the first character must be alphabetic and
  #    the next two characters must be either both digits or both alphabetic.
  # 6. If the length is 12, then the first two characters must be alphabetic
  #    and the remaining characters digits.

  def normalized_is_valid?(normalized = self.normalized)
    return false if normalized.nil?
    return false unless (8..12).cover?(normalized.size) # 1
    return false unless ALLDIGITS.match normalized[-8..-1] # 2

    firstchar = normalized[0]


    case normalized.size
    when 9
      return false unless ALLALPHAS.match normalized[0] # 3
    when 10
      firsttwo  = normalized[0..1]
      return false unless ALLALPHAS.match(firsttwo) or
          ALLDIGITS.match(firsttwo) # 4
    when 11
      nexttwo = normalized[1..2]
      return false unless ALLALPHAS.match(firstchar) and
          (ALLALPHAS.match(nexttwo) or ALLDIGITS.match(nexttwo))
    when 12
      return false unless ALLALPHAS.match(firsttwo) and ALLDIGITS.match(normalize[2..-1])
    end

    true
  end


end
