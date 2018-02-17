class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :email
      t.index :email, unique: true
      t.integer :role
      t.timestamps
    end
  end
end
