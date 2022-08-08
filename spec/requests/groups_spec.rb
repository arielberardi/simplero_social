require 'rails_helper'

RSpec.describe '/groups', type: :request do
  let(:group) { FactoryBot.create(:group) }
  let(:mock_post) { FactoryBot.create(:post, group: group) }
  let(:valid_attributes) { attributes_for(:group) }
  let(:invalid_attributes) { attributes_for(:group, title: '') }

  before { sign_in FactoryBot.create(:user) }

  describe 'GET /index' do
    before { group }

    subject do
      get groups_url
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(group.title) }
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
      get group_url(group)
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(group.title) }
    it { expect(subject.body).to include(mock_post.title) }
  end

  describe 'GET /edit' do
    subject do
      get edit_group_url(group)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'POST /create' do
    let(:group_attributes) { valid_attributes }

    subject do
      post groups_url, params: { group: group_attributes }
      response
    end

    it { expect { subject }.to change(Group, :count).by(1) }
    it { is_expected.to redirect_to(group_url(Group.last)) }

    context 'with invalid parameters' do
      let(:group_attributes) { invalid_attributes }

      it { expect { subject }.to change(Group, :count).by(0) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { attributes_for(:group) }

    before { group }

    subject do
      put group_url(group), params: { group: new_attributes }
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
        expect(Group.last.title).to eq(group.title)
      end

      it { expect(subject).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'DELETE /destroy' do
    before do
      group
      mock_post
    end

    subject do
      delete group_url(group)
      response
    end

    it { expect { subject }.to change(Group, :count).by(-1) }
    it { expect { subject }.to change(Post, :count).by(-1) }
    it { is_expected.to redirect_to(groups_url) }
  end
end
