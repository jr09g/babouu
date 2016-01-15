class User < ActiveRecord::Base
  #adding user abilities from authority gem
  include Authority::UserAbilities
  #method for roles added to user through rolify gem
  rolify
  has_many :receipts
  has_many :expense_reports
  has_one :relationship
  has_one :business, through: :relationship
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_business
  	@relationships = Relationship.where(:user_id => current_user.id)
  	@business_num = @relationships.business_id
  	@business_name = Business.where(:id => @business_num)

  	if @business_name?
  	  return @business_name
  	else
  	  return false
  	end
  	
  end

end
