FactoryBot.define do
  factory :review do
    book
    user
    rating { rand(Review::VALID_RATING_RANGE) }
    description { nil }

    trait :with_description do
      description { Faker::Lorem.paragraph }
    end

    trait :with_profane_description do
      description { 'This book is LAME and it sucks' }
    end
  end
end
