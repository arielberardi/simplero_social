class CommentsController < ApplicationController
  before_action :authenticate_user!

  before_action :set_post
  before_action :set_comment, only: %i[show edit update destroy]

  # POST /comments
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to redirect_to_post, notice: 'Comment was successfully created.'
    else
      redirect_to redirect_to_post, status: :unprocessable_entity
    end
  end

  def edit
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      redirect_to redirect_to_post, notice: 'Comment was successfully updated.'
    else
      redirect_to redirect_to_post, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy

    # Using turbo requires to return status. https://github.com/rails/rails/issues/44170
    redirect_to redirect_to_post, status: :see_other, notice: 'Comment was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def redirect_to_post
    group_post_url(@post.group.id, @post)
  end
end
