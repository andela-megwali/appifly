class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.references :airline, index: true, foreign_key: true
      t.string :origin
      t.string :destination
      t.integer :seat
      t.datetime :departure
      t.datetime :arrival
      t.string :airplane
      t.string :flight_code
      t.string :flight_type
      t.integer :flight_cost

      t.timestamps null: false
    end
  end
end
