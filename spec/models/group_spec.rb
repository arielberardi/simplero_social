# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { FactoryBot.create(:group) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:group_enrollements) }
  it { is_expected.to have_many(:users).through(:group_enrollements) }
end
