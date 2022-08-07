FactoryBot.define do
  factory :comment do
    content { Faker::Movie.quote }
    post
  end
end
