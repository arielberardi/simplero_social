require 'rails_helper'

RSpec.describe '/posts', type: :request do
  let(:group) { FactoryBot.create(:group) }
  let(:group_id) { group.id }

  let(:mock_post) { FactoryBot.create(:post, group: group) }
  let(:valid_attributes) { attributes_for(:post) }
  let(:invalid_attributes) { attributes_for(:post, title: '') }

  describe 'GET /index' do
    before { mock_post }

    subject do
      get group_posts_url(group_id)
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(Post.last.title) }
  end

  describe 'GET /show' do
    subject do
      get group_post_url(group_id, mock_post)
      response
    end

    it { is_expected.to be_successful }
    it { expect(subject.body).to include(Post.last.title) }
  end

  describe 'GET /new' do
    subject do
      get new_group_post_url(group_id)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'GET /edit' do
    before { mock_post }

    subject do
      get edit_group_post_url(group_id, mock_post)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'POST /create' do
    let(:post_attributes) { valid_attributes }

    subject do
      post group_posts_url(group_id), params: { post: post_attributes }
      response
    end

    it { expect { subject }.to change(Post, :count).by(1) }
    it { is_expected.to redirect_to(group_post_url(group_id, Post.last)) }

    context 'with invalid parameters' do
      let(:post_attributes) { invalid_attributes }

      it { expect { subject }.to change(Post, :count).by(0) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { attributes_for(:post) }

    before { mock_post }

    subject do
      put group_post_url(group_id, mock_post), params: { post: new_attributes }
      response
    end

    it 'changes an attribute of current post' do
      subject
      expect(Post.last.title).to eq(new_attributes[:title])
    end

    it { is_expected.to redirect_to(group_post_url(group_id, mock_post)) }

    context 'with invalid parameters' do
      let(:new_attributes) { invalid_attributes }

      it { expect(subject).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'DELETE /destroy' do
    before { mock_post }

    subject do
      delete group_post_url(group_id, mock_post)
      response
    end

    it { expect { subject }.to change(Post, :count).by(-1) }
    it { is_expected.to redirect_to(group_posts_url(group_id)) }
  end
end
