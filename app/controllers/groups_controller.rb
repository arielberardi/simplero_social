# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, except: %i[index new create]
  before_action :validate_group_ownership!, only: %i[edit update destroy leave accept_join]
  before_action :validate_user_enrollment!, only: :show

  def index
    @groups = Group.all
  end

  def show
    @posts = @group.posts.all
  end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        GroupEnrollment.create(user: current_user, group: @group, joined: true)

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

  def destroy
    @group.destroy

    redirect_to groups_url, notice: locale('destroyed')
  end

  def join
    GroupEnrollment.create(user: current_user, group: @group, joined: true)

    redirect_to @group, notice: I18n.t('groups.join.success')
  end

  def leave
    user = User.find(params[:user_id])
    raise if current_user != @group.user || user == @group.user

    GroupEnrollment.find_by(user: user, group: @group).destroy

    redirect_to @group, notice: I18n.t('groups.leave.success')
  rescue StandardError
    redirect_to @group, notice: I18n.t('groups.leave.failed')
  end

  def request_join
    GroupEnrollment.create(user: current_user, group: @group)

    redirect_to groups_url, notice: I18n.t('groups.join.success')
  end

  def accept_join
    user = User.find(params[:user_id])
    raise if current_user != @group.user || user == @group.user

    enrrollement = GroupEnrollment.find_by(user: user, group: @group)

    params[:accepted] == 'true' ? enrrollement.update(joined: true) : enrrollement.destroy

    redirect_to @group, notice: I18n.t('groups.leave.success')
  rescue StandardError
    redirect_to @group, notice: I18n.t('groups.leave.failed')
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:title, :privacy).merge(user: current_user)
  end

  def validate_group_ownership!
    validate_ownership!(@group)
  end

  def locale(action)
    I18n.t('notice.success', action: action, resource: 'Group')
  end
end
