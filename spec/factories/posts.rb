# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { Faker::Movie.title }
    content { Faker::Movie.quote }

    group
  end
end
