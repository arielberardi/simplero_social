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

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.append('groups',
                                                    partial: 'groups/group',
                                                    locals: { group: @group })
        end
        format.html { redirect_to group_url(@group), notice: 'Group was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@group,
                                                    partial: 'groups/show_group',
                                                    locals: { group: @group })
        end
        format.html { redirect_to group_url(@group), notice: 'Group was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
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
