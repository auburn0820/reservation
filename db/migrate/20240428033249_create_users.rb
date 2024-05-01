class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :user_id, null: false
      t.string :email
      t.string :encrypted_password
      t.string :role, default: User::Role::CUSTOMER
      t.timestamps
    end

    add_index :users, :user_id, unique: true
  end
end
