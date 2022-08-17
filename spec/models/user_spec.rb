# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryBot.create(:user) }

  it { is_expected.to have_many(:groups) }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:group_enrollments) }
  it { is_expected.to have_many(:joined_groups).through(:group_enrollments) }
end
