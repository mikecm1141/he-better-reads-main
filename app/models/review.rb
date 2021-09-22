class Review < ApplicationRecord
  VALID_RATING_RANGE = (1..5).freeze

  belongs_to :book
  belongs_to :user

  validates :user_id,
            uniqueness: { scope: :book_id, message: 'can only review a book once' },
            presence: true
  validates :rating,
            presence: true,
            numericality: {
              greater_than_or_equal_to: VALID_RATING_RANGE.min,
              less_than_or_equal_to: VALID_RATING_RANGE.max,
              only_integer: true,
            }
  validate :no_profanity_in_description

  private

  def no_profanity_in_description
    return if description.blank?

    profanity_filter = ProfanityFilter.new(description)
    return if profanity_filter.clean?

    errors.add(:description, "contains disallowed terms: #{profanity_filter.filtered_terms.to_sentence}")
  end
end
