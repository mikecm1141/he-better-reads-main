FactoryBot.define do
  factory :review do
    book
    user
    rating { 1 }
    description { nil }
  end
end
