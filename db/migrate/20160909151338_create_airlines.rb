class CreateAirlines < ActiveRecord::Migration
  def change
    create_table :airlines do |t|
      t.references :airport, index: true, foreign_key: true
      t.string :name
      t.string :airline_code
      t.integer :rating

      t.timestamps null: false
    end
  end
end
