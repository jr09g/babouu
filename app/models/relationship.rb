class Relationship < ActiveRecord::Base
  belongs_to :business
  belongs_to :user

  #check if relationship exists
  def self.relationship_check(user_id)
  	@user_id = user_id
  	#@relationship_find = Relationship.where(:user_id => @user_id)
  	@does_exist

  	#loop through all relatioships to check if user_id already has one
  	Relationship.each do |relationship|
  	  if relationship.user_id == @user_id
  	  	@does_exist = false
  	  	break
  	  else
  	  	@does_exist = true
      end
    end

  	#if @relationship_find == nil
  	#  @does_exist = true
  	#else
  	#  @does_exist = false
  	#end

  	return @does_exist

  end

end