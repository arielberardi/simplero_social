# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { FactoryBot.create(:comment) }

  it { is_expected.to validate_presence_of(:content) }

  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:parent).class_name('Comment').optional }
  it { is_expected.to have_many(:replies).class_name('Comment') }
end
