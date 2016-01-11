class User < ActiveRecord::Base
  #adding user abilities from authority gem
  include Authority::UserAbilities
  #method for roles added to user through rolify gem
  rolify
  has_many :receipts
  has_many :expense_reports
  has_one :business, through: :relationship
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
