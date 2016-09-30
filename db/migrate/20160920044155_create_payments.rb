class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :booking, foreign_key: true

      t.timestamps null: false
    end
  end
end
