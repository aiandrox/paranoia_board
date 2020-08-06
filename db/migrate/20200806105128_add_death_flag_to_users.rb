class AddDeathFlagToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :dead, :boolean, null: false, default: 0
  end
end
