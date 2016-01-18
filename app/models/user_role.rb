class UserRole < ActiveRecord::Base
	belongs_to :User
	belongs_to :role 

end