class AddSectorToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :sector, :string, limit: 3, null: false
    remove_column :users, :last_name, :string
  end
end
