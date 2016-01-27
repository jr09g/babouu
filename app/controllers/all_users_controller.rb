class AllUsersController < ApplicationController
  before_action :set_all_user, only: [:show]
  before_action :authenticate_business!

  def show
  end

  private

  def set_all_user
  	@all_user = User.find(params[:id])
  end

end
