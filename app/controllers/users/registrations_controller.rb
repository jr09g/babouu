class Users::RegistrationsController < Devise::RegistrationsController

  def create
  	#inherit all methods and lines originally in create method
  	super
  	#once the user (resource) is created, apply the default role to the user
  	#once ability is added for businesses to invite new users, this will need to be amended to immediately apply
  	#the correct role
  	resource.add_role :standard
  end

  private

  def sign_up_params
	params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
	params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end

end