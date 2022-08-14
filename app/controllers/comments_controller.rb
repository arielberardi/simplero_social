# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[update destroy]
  before_action -> { validate_ownership!(@comment) }, only: %i[update destroy]
  before_action :set_group, only: :create
  before_action :validate_user_enrollment!, only: :create

  # POST /comments
  def create
    @comment = @post.comments.new(comment_params.merge(user: current_user))

    sent_notification

    if @comment.save
      redirect_to redirect_to_post, notice: locale('created')
    else
      redirect_to redirect_to_post, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to redirect_to_post, notice: locale('updated')
    else
      redirect_to redirect_to_post, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    # Using turbo requires to return status. https://github.com/rails/rails/issues/44170
    redirect_to redirect_to_post, status: :see_other, notice: locale('destroyed')
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

  def redirect_to_post
    group_post_url(@post.group.id, @post)
  end

  def locale(action)
    I18n.t('notice.success', action: action, resource: 'Comment')
  end

  def sent_notification
    if @comment.reply?
      return if @comment.parent.user == current_user

      content = "#{current_user.email} replied to your comment"
    else
      return if @post.user == current_user

      content = "#{current_user.email} commented your post"
    end

    html = ApplicationController.render partial: 'layouts/notification',
                                        locals: { content: content, link: redirect_to_post },
                                        formats: [:html]

    ActionCable.server.broadcast("notification:#{@post.user.id}", { html: html })
  end
end
