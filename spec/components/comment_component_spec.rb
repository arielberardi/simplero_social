# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentComponent, type: :component do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }
  let(:comment) { FactoryBot.create(:comment, post: post, user: user) }
  let(:reply) { FactoryBot.create(:comment, post: post, parent_id: comment.id, user: user) }

  before do
    reply
    sign_in user
  end

  subject { render_inline(CommentComponent.new(comment: comment, current_user: user)) }

  it 'renders comment body' do
    subject
    expect(page).to have_content comment.content.to_plain_text
  end

  it 'renders comment replies' do
    subject
    expect(page).to have_content comment.replies.first.content.to_plain_text
  end

  it 'renders comment actions' do
    subject
    expect(page).to have_link 'Delete'
    expect(page).to have_selector 'button', text: 'Edit'
    expect(page).to have_selector 'button', text: 'Reply'
  end

  it 'renders last update status' do
    subject
    expect(page).to have_content "#{time_ago_in_words(comment.created_at)} ago"
  end

  context 'when user is not the owner' do
    let(:owner) { FactoryBot.create(:user) }
    let(:comment) { FactoryBot.create(:comment, post: post, user: owner) }
    let(:reply) { FactoryBot.create(:comment) }

    it "doesn't render all comment actions" do
      subject

      expect(page).to_not have_link 'Delete'
      expect(page).to_not have_selector 'button', text: 'Edit'
      expect(page).to have_selector 'button', text: 'Reply'
    end
  end
end
