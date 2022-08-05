class PostsController < ApplicationController
  before_action :set_group
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = @group.posts.all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = @group.posts.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = @group.posts.new(post_params)

    if @post.save
      redirect_to group_post_url(@group, @post), notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    if @post.update(post_params)
      redirect_to group_post_url(@group, @post), notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy

    redirect_to group_posts_url, notice: 'Post was successfully destroyed.'
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
end
