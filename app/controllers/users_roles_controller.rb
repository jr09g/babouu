class UsersRolesController < ApplicationController
  before_action :set_user_role, only: [:edit, :update]
  
  def edit
  	#@roles = Role.all
  	#instance variable that cretaes dropdown to edit employee roles; standard role omitted because it is not a valid role in business relationship scope
  	@roles = Role.where.not(id: 1)
  end

  def update

  end

  private

  def set_user_role
  	@user_role = UsersRole.find(params[:id])
  end

end