FactoryBot.define do
  factory :review do
    book
    user
    rating { rand(Review::VALID_RATING_RANGE) }
    description { nil }
  end
end
