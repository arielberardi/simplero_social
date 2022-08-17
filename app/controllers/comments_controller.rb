# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_group, only: :create
  before_action :set_comment, only: %i[update destroy]
  before_action :validate_user_enrollment!, only: :create
  before_action :validate_comment_ownership!, only: %i[update destroy]

  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    send_notification

    if @comment.save
      redirect_to current_post_url, notice: locale('created')
    else
      redirect_to current_post_url, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to current_post_url, notice: locale('updated')
    else
      redirect_to current_post_url, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    # Using turbo requires to return status. https://github.com/rails/rails/issues/44170
    redirect_to current_post_url, status: :see_other, notice: locale('destroyed')
  end

  private

  def set_group
    @group = @post.group
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def validate_comment_ownership!
    validate_ownership!(@comment)
  end

  def current_post_url
    group_post_url(@post.group.id, @post)
  end

  def locale(action)
    I18n.t('notice.success', action: action, resource: 'Comment')
  end

  def send_notification
    if @comment.reply?
      owner = @comment.parent.user
      content = "#{current_user.email} replied to your comment"
    else
      owner = @post.user
      content = "#{current_user.email} commented your post"
    end

    return if owner == current_user

    html = ApplicationController.render(partial: 'layouts/notification', formats: [:html],
                                        locals: { content: content, link: current_post_url })

    ActionCable.server.broadcast("notification:#{owner.id}", { html: html })
    NotificationMailer.notify(owner, content).deliver_now
  end
end
