# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { Faker::Movie.quote }

    post
    user
  end
end
