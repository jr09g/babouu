class UsersRolesController < ApplicationController
  before_action :set_user_role, only: [:edit, :update]
  
  def edit
  	#@roles = Role.all
  	#instance variable that cretaes dropdown to edit employee roles; standard role omitted because it is not a valid role in business relationship scope
  	@roles = Role.where.not(id: [1,2])
  end

  def update
  	respond_to do |format|
      if @user_role.update(user_role_params)
        format.html { redirect_to relationships_path, notice: 'Relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: relationships_path }
      else
        format.html { render :edit }
        format.json { render json: @user_role.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user_role
  	@user_role = UsersRole.find(params[:id])
  end

  def user_role_params
  	params.require(:users_role).permit(:user_id, :role_id)
  end

end