class Group < ActiveRecord::Base
  belongs_to :business
  has_many :users, through: :users_group

end
