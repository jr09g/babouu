class AddInReplyToToReceipts < ActiveRecord::Migration
  def change
    add_column :receipts, :in_reply_to, :string
  end
end
