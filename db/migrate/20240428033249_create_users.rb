class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :email
      t.string :encrypted_password
      t.integer :role, default: 0
      t.timestamps
    end

    add_index :users, :user_id, unique: true
  end
end
