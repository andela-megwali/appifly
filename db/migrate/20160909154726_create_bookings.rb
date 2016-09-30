class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :reference_id
      t.integer :total_cost
      t.string :paid
      t.string :travel_class
      t.references :flight, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
