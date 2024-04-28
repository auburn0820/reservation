class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.string :booking_id, null: false
      t.string :user_id, null: false
      t.timestamps
    end

    add_index :bookings, :booking_id, unique: true
    add_index :bookings, :user_id
  end
end