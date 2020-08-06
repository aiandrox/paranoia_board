class AddSenderNameToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :sender_name, :string, null: false
  end
end
