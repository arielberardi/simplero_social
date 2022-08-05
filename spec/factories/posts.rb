FactoryBot.define do
  factory :post do
    title { Faker::Movie.title }
    content { Faker::Movie.quote }
  end
end
