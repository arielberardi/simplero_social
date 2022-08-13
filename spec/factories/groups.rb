# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    title { Faker::Movie.title }
    privacy { 'open' }
    user
  end
end
