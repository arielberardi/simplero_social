# frozen_string_literal: true

FactoryBot.define do
  factory :group_enrollement do
    joined { false }

    group
    user
  end
end
