class Relationship < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  #check if relationship exists
  def self.relationship_check(user_id)
  	@user_id = user_id

  	@relationship_val = Relationship.find(@user_id)

  	if @relationship_val == nil
  	  #relationship does not exist, return true
  	  return true
  	else
  	  #relationship does exist, return false
  	  return false
  	end

  end

end