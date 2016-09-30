class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :name
      t.string :continent
      t.string :country
      t.string :state_and_code
      t.string :jurisdiction
      t.integer :rating

      t.timestamps null: false
    end
  end
end
