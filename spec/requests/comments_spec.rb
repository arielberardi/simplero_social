require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let(:mock_post) { FactoryBot.create(:post) }
  let(:post_id) { mock_post.id }

  let(:comment) { FactoryBot.create(:comment, post: mock_post) }
  let(:valid_attributes) { attributes_for(:comment) }
  let(:invalid_attributes) { attributes_for(:comment, content: '') }

  describe 'GET /index' do
    before { comment }

    subject do
      get post_comments_url(post_id)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'GET /show' do
    subject do
      get post_comment_url(post_id, comment)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'GET /new' do
    subject do
      get new_post_comment_url(post_id)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'GET /edit' do
    before { comment }

    subject do
      get edit_post_comment_url(post_id, comment)
      response
    end

    it { is_expected.to be_successful }
  end

  describe 'POST /create' do
    let(:comment_attributes) { valid_attributes }

    subject do
      post post_comments_url(post_id), params: { comment: comment_attributes }
      response
    end

    it { expect { subject }.to change(Comment, :count).by(1) }
    it { is_expected.to redirect_to(post_comment_url(Comment.last.post.id, Comment.last)) }

    context 'with invalid parameters' do
      let(:comment_attributes) { invalid_attributes }

      it { expect { subject }.to change(Comment, :count).by(0) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { attributes_for(:comment) }

    before { comment }

    subject do
      put post_comment_url(post_id, comment), params: { comment: new_attributes }
      response
    end

    it { is_expected.to redirect_to(post_comment_url(post_id, comment)) }

    context 'with invalid parameters' do
      let(:new_attributes) { invalid_attributes }

      it { expect(subject).to have_http_status(:unprocessable_entity) }
    end
  end

  describe 'DELETE /destroy' do
    before { comment }

    subject do
      delete post_comment_url(post_id, comment)
      response
    end

    it { expect { subject }.to change(Comment, :count).by(-1) }
    it { is_expected.to redirect_to(post_comments_url) }
  end
end
