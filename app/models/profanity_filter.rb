class ProfanityFilter
  DISALLOWED_TERMS = ['lame', 'butt', 'sucks'].freeze

  def initialize(text)
    @text = text.to_s
  end

  def filtered_terms
    @_filtered_terms ||= DISALLOWED_TERMS.select do |disallowed_term|
      pattern = Regexp.new(disallowed_term, Regexp::IGNORECASE)

      text.match?(pattern)
    end
  end

  def clean?
    filtered_terms.empty?
  end

  private

  attr_reader :text
end
