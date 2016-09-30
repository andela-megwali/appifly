class CreateFlights < ActiveRecord::Migration
  def change
    create_table :flights do |t|
      t.references :airport, index: true, foreign_key: true
      t.string :origin
      t.string :destination
      t.integer :seat
      t.datetime :departure
      t.datetime :arrival
      t.string :airline
      t.string :code
      t.string :jurisdiction
      t.integer :cost
      t.string :status

      t.timestamps null: false
    end
  end
end
