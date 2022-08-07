require 'rails_helper'

RSpec.describe Group, type: :model do
  subject { FactoryBot.create(:group) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title) }

  it { is_expected.to have_many(:posts) }
end