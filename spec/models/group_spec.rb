# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { FactoryBot.create(:group) }

  subject { group }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_uniqueness_of(:title) }
  it { is_expected.to validate_presence_of(:privacy) }

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:group_enrollments) }
  it { is_expected.to have_many(:users).through(:group_enrollments) }

  context 'when group has members' do
    before { FactoryBot.create(:group_enrollment, group: group, joined: true) }

    it { expect(subject.members.count).to eq(1) }
    it { expect(subject.members.last).to eq(GroupEnrollment.last.user) }
  end

  context 'when group has requests pending' do
    before { FactoryBot.create(:group_enrollment, group: group) }

    it { expect(subject.requests.count).to eq(1) }
    it { expect(subject.requests.last).to eq(GroupEnrollment.last.user) }
  end
end
