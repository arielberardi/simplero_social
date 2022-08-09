# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { FactoryBot.create(:post) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title).scoped_to(:group_id) }
  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to belong_to(:group) }
  it { is_expected.to have_many(:comments) }
end
