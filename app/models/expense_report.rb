class ExpenseReport < ActiveRecord::Base
  #
  resourcify
  #provides ability for users to send and receive expense reports according to user role
  include Authority::UserAbilities
  belongs_to :user

end
