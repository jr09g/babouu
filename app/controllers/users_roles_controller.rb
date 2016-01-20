class UsersRolesController < ApplicationController
  before_action :set_user_role, only: [:edit, :update]
  
  def edit
  	@roles = Role.all
  end

  def update

  end

  private

  def set_user_role
  	@user_role = UsersRole.find(params[:id])
  end

end