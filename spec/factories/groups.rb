FactoryBot.define do
  factory :group do
    title { Faker::Movie.title }
  end
end
