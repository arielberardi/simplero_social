# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/comments', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:group) { FactoryBot.create(:group) }
  let(:group_id) { group.id }
  let(:enroll_user) { enroll_user_in_group(user, group) }

  let(:mock_post) { FactoryBot.create(:post, group: group) }
  let(:post_id) { mock_post.id }

  let(:comment) { FactoryBot.create(:comment, post: mock_post, user: user) }
  let(:valid_attributes) { FactoryBot.attributes_for(:comment) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:comment, content: '') }

  before do
    sign_in user
    enroll_user
  end

  describe 'POST /create' do
    let(:comment_attributes) { valid_attributes }

    subject do
      post post_comments_url(post_id), params: { comment: comment_attributes }
      response
    end

    it { expect { subject }.to change(Comment, :count).by(1) }
    it { is_expected.to redirect_to(group_post_url(group_id, post_id)) }

    context 'with invalid parameters' do
      let(:comment_attributes) { invalid_attributes }

      it { expect { subject }.to change(Comment, :count).by(0) }
      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'when user is not enrolled' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:mock_group) { FactoryBot.create(:group, user: owner_user) }
      let(:enroll_user) { nil }

      it { is_expected.to redirect_to(groups_url) }
    end
  end

  describe 'PATCH /update' do
    let(:new_attributes) { FactoryBot.attributes_for(:comment) }

    before { comment }

    subject do
      put post_comment_url(post_id, comment), params: { comment: new_attributes }
      response
    end

    it { is_expected.to redirect_to(group_post_url(group_id, post_id)) }

    it 'changes the content of the comment' do
      subject
      expect(Comment.last.content.to_plain_text).to eq(new_attributes[:content])
    end

    context 'with invalid parameters' do
      let(:new_attributes) { invalid_attributes }

      it 'does not change the content of the comment' do
        subject
        expect(Comment.last.content.to_plain_text).to eq(comment.content.to_plain_text)
      end

      it { expect(subject).to have_http_status(:unprocessable_entity) }
    end

    context 'user is not the owner of the comment' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:comment) { FactoryBot.create(:comment, post: mock_post, user: owner_user) }

      it { is_expected.to redirect_to(groups_url) }

      context 'and is the owner of the group' do
        let(:group) { FactoryBot.create(:group, user: user) }

        it { is_expected.to redirect_to(group_post_url(group_id, post_id)) }

        it 'changes the content of the comment' do
          subject
          expect(Comment.last.content.to_plain_text).to eq(new_attributes[:content])
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    before { comment }

    subject do
      delete post_comment_url(post_id, comment)
      response
    end

    it { expect { subject }.to change(Comment, :count).by(-1) }
    it { is_expected.to redirect_to(group_post_url(group_id, post_id)) }

    context 'user is not the owner of the comment' do
      let(:owner_user) { FactoryBot.create(:user) }
      let(:comment) { FactoryBot.create(:comment, post: mock_post, user: owner_user) }

      it { is_expected.to redirect_to(groups_url) }

      context 'and is the owner of the group' do
        let(:group) { FactoryBot.create(:group, user: user) }

        it { expect { subject }.to change(Comment, :count).by(-1) }
        it { is_expected.to redirect_to(group_post_url(group_id, post_id)) }
      end
    end
  end
end
