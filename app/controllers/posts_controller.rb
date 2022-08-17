# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group
  before_action :set_post, only: %i[show update destroy]
  before_action :validate_post_ownership!, only: %i[update destroy]
  before_action :validate_user_enrollment!, only: :show

  def show
    @comments = @post.comments.parents
  end

  def create
    @post = @group.posts.new(post_params.merge(user: current_user))

    if @post.save
      redirect_to group_url(@group), notice: locale('created')
    else
      redirect_to group_url(@group), status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to group_url(@group), notice: locale('updated')
    else
      redirect_to group_url(@group), status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    # Using turbo requires to return status. https://github.com/rails/rails/issues/44170
    redirect_to group_url(@group), status: :see_other, notice: locale('destroyed')
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_post
    @post = @group.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def validate_post_ownership!
    validate_ownership!(@post)
  end

  def locale(action)
    I18n.t('notice.success', action: action, resource: 'Post')
  end
end
