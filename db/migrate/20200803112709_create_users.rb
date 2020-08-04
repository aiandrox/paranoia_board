class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false, limit: 6
      t.integer :clone_number, null: false, default: 1
      t.string :user_digest, null: false
      t.timestamps
    end
  end
end
