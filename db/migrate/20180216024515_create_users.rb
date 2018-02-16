class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_hash
      t.integer :role

      t.timestamps
    end
  end
end
