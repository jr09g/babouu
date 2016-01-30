class ExpenseReport < ActiveRecord::Base
  #resourcify gives ability for expense reports to have different levels of authorization from users depending on role
  resourcify
  #provides ability for users to send and receive expense reports according to user role
  include Authority::UserAbilities
  belongs_to :user
  has_many :receipts
  has_many :expense_report_statuses

  def send_to_manager()

  end

end
