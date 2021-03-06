class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :title
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :telephone
      t.string :username
      t.boolean :admin_user
      t.boolean :subscription
      t.string :password_digest

      t.timestamps null: false
    end
  end
end
