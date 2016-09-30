class CreatePassengers < ActiveRecord::Migration
  def change
    create_table :passengers do |t|
      t.references :booking, index: true, foreign_key: true
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :telephone
      t.string :nationality
      t.string :luggage

      t.timestamps null: false
    end
  end
end
