class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name
      t.string :country
      t.string :state
      t.string :airport_type
      t.integer :rating

      t.timestamps null: false
    end
  end
end
