# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/groups', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:mock_group) { FactoryBot.create(:group, user: user) }
  let(:mock_post) { FactoryBot.create(:post, group: mock_group) }
  let(:valid_attributes) { FactoryBot.attributes_for(:group) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:group, title: '') }
  let(:enroll_user) { enroll_user_in_group(user, mock_group) }

  before do
    sign_in user
    enroll_user
  end

  describe 'GET /index' do
    before { mock_group }

    subject do
      get groups_url
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(mock_group.title) }
  end

  describe 'GET /new' do
    subject do
      get new_group_url
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'GET /show' do
    before { mock_post }

    subject do
      get group_url(mock_group)
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(mock_group.title) }
    it { expect(subject.body).to include(mock_post.title) }

    context 'when user is not enrolled' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: owner_user) }
      let(:enroll_user) { nil }

      it { is_expected.to redirect_to(groups_url) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_group_url(mock_group)
      response
    end

    it { is_expected.to be_successful }

    context 'when user is not the owner' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: owner_user) }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe 'POST /create' do
    let(:group_attributes) { valid_attributes }

    subject do
      post groups_url, params: { group: group_attributes }
      response
    end

    it { expect { subject }.to change(Group, :count).by(1) }
    it { is_expected.to redirect_to(group_url(Group.last)) }
    it { expect(Group.last).to eq(user.joined_groups.last) }

    context 'with invalid parameters' do
      let(:group_attributes) { invalid_attributes }

      it { expect { subject }.to change(Group, :count).by(0) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { FactoryBot.attributes_for(:group) }

    before { mock_group }

    subject do
      put group_url(mock_group), params: { group: new_attributes }
      response
    end

    it { is_expected.to redirect_to(group_url) }

    it 'changes group attributes' do
      subject
      expect(Group.last.title).to eq(new_attributes[:title])
    end

    context 'with invalid parameters' do
      let(:new_attributes) { invalid_attributes }

      it 'does not change group attributes' do
        subject
        expect(Group.last.title).to eq(mock_group.title)
      end

      it { expect(subject).to have_http_status(:unprocessable_entity) }
    end

    context 'when user is not the owner' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: owner_user) }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe 'DELETE /destroy' do
    before do
      mock_group
      mock_post
    end

    subject do
      delete group_url(mock_group)
      response
    end

    it { expect { subject }.to change(Group, :count).by(-1) }
    it { expect { subject }.to change(Post, :count).by(-1) }
    it { is_expected.to redirect_to(groups_url) }

    context 'when user is not the owner' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: owner_user) }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe 'GET /join' do
    let(:owner_user) { FactoryBot.create(:user) }
    let(:mock_group) { FactoryBot.create(:group, user: owner_user) }
    let(:enroll_user) { nil }

    before { enroll_user_in_group(owner_user, mock_group) }

    subject do
      get join_group_url(mock_group)
      response
    end

    it { is_expected.to redirect_to(group_url(mock_group)) }
    it { expect { subject }.to change(GroupEnrollement, :count).by(1) }

    context 'when user is the owner or is joined' do
      let(:user) { owner_user }

      it { is_expected.to redirect_to(group_url(mock_group)) }
      it { expect { subject }.to change(GroupEnrollement, :count).by(0) }
    end
  end

  describe 'GET /leave' do
    let(:new_user) { FactoryBot.create(:user) }

    before { enroll_user_in_group(new_user, mock_group) }

    subject do
      get leave_group_url(mock_group, new_user)
      response
    end

    it { is_expected.to redirect_to(group_url(mock_group)) }
    it { expect { subject }.to change(GroupEnrollement, :count).by(-1) }

    it 'removes join asociation with the user' do
      subject
      expect(new_user.joined_groups).to_not include(mock_group)
    end

    context 'when user is not the owner' do
      let(:new_owner) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: new_owner) }

      it { is_expected.to have_http_status(:unauthorized) }
      it { expect { subject }.to change(GroupEnrollement, :count).by(0) }
    end
  end
end
