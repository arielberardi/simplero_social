# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: %i[show edit update destroy join]
  before_action -> { validate_ownership!(@group) }, only: %i[edit update destroy]
  before_action :validate_user_enrollment!, only: :show

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
  def edit; end

  # POST /groups
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        GroupEnrollement.create(user: current_user, group: @group)

        format.turbo_stream do
          render turbo_stream: turbo_stream.append('groups',
                                                   partial: 'groups/group',
                                                   locals: { group: @group })
        end
        format.html { redirect_to group_url(@group), notice: locale('created') }
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
        format.html { redirect_to group_url(@group), notice: locale('updated') }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  def destroy
    @group.destroy

    redirect_to groups_url, notice: locale('destroyed')
  end

  # POST /groups/1/join
  def join
    GroupEnrollement.create(user: current_user, group: @group)

    redirect_to @group, notice: I18n.t('groups.join.success')
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:title).merge(user: current_user)
  end

  def locale(action)
    I18n.t('notice.success', action: action, resource: 'Group')
  end
end
