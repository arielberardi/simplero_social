class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups
  def index
    @groups = Group.all
  end

  # GET /groups/1
  def show
    @posts = @group.posts.all
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to group_url(@group), notice: 'Group was successfully created.'
    else
      redirect_to groups_url, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /groups/1
  def update
    if @group.update(group_params)
      redirect_to group_url(@group), notice: 'Group was successfully updated.'
    else
      redirect_to group_url(@group), status: :unprocessable_entity
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy

    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:title)
  end
end
